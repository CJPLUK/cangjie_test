# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.

'''
File: name_validation_tests.py

Description:
Regression tests for test name validation and discovery
'''

import unittest
from pathlib import Path
from tempfile import TemporaryDirectory
from unittest.mock import Mock, patch

from core.config import Config
from core.report_manager import ReportManager
from core.task_manager import TaskManager
from drivers.test.base_test import TestResult
from drivers.test.test import Test


class NameValidationTests(unittest.TestCase):
  '''Validate explicit and default names before tests enter the execution queue'''

  illegal_characters = '<>:"/\\|?*\x00'
  name_templates = ('{}valid', 'val{}id', 'valid{}')

  def setUp(self):
    directory = TemporaryDirectory()
    self.addCleanup(directory.cleanup)
    self.test_dir = Path(directory.name)

  def _write_test(self, filename, name=None):
    source = 'main(): Int64 { return 0 }\n'
    if name is not None:
      source = f'/*\n  @Name: {name}\n*/\n' + source
    test_path = self.test_dir / filename
    test_path.write_text(source, encoding='utf-8')
    return str(test_path)

  def test_rejects_illegal_characters_at_every_position(self):
    '''Reject every forbidden character at the start, middle and end of @Name'''
    for character in self.illegal_characters:
      for template in self.name_templates:
        name = template.format(character)
        with self.subTest(name=name):
          test_path = self._write_test('test_explicit.cj', name)
          with self.assertLogs('drivers.test.base_test', level='ERROR'):
            candidate = Test(test_path)
            # The name getter can derive a fallback, so inspect the stored name.
            self.assertIsNone(candidate.to_dict()['name'])
            self.assertFalse(candidate.is_valid())

  def test_accepts_legal_explicit_names(self):
    '''Keep legal names unchanged, including allowed punctuation and Unicode'''
    for name in ('ok', 'test_123', 'test-name.v2', 'two words', '中文名称'):
      with self.subTest(name=name):
        candidate = Test(self._write_test('test_explicit.cj', name))
        self.assertEqual(candidate.name, name)
        self.assertTrue(candidate.is_valid())

  def test_accepts_legal_default_names(self):
    '''Derive a valid name from the filename when @Name is absent'''
    for filename in ('test_default.cj', 'test.multiple.dots.cj', 'test_name-v2.cj'):
      with self.subTest(filename=filename):
        candidate = Test(self._write_test(filename))
        self.assertEqual(candidate.name, Path(filename).stem)
        self.assertTrue(candidate.is_valid())

  def test_rejects_illegal_default_names(self):
    '''Apply the same validation to names derived from the filename'''
    test_path = self._write_test('test_default.cj')
    for filename in ('test:invalid.cj', 'test?invalid.cj', 'test*invalid.cj'):
      with self.subTest(filename=filename):
        # These filenames cannot be created on Windows. Only mock basename;
        # source loading, default name derivation and validation remain real.
        with patch('drivers.test.base_test.path.basename', return_value=filename):
          with self.assertLogs('drivers.test.base_test', level='ERROR'):
            candidate = Test(test_path)
            self.assertIsNone(candidate.to_dict()['name'])
            self.assertFalse(candidate.is_valid())

  def test_discovery_excludes_invalid_names(self):
    '''Report invalid tests as ERRORED and collect only valid tests for execution'''
    valid_paths = {
        self._write_test('test_valid.cj', 'valid_name-1.2'),
        self._write_test('test_default.cj'),
    }
    invalid_paths = set()
    for character in self.illegal_characters:
      for position, template in enumerate(self.name_templates):
        filename = f'test_invalid_{ord(character)}_{position}.cj'
        invalid_paths.add(self._write_test(filename, template.format(character)))

    cfg = Config()
    cfg.work_directory = str(self.test_dir / 'work')
    cfg.tests_root_path = str(self.test_dir)
    cfg.included_tests = ['*']
    reporter = Mock(spec=ReportManager)
    with self.assertLogs(level='ERROR'):
      manager = TaskManager(cfg, reporter)

    self.assertEqual({candidate.test_path for candidate in manager.test_list}, valid_paths)
    self.assertEqual(len(manager.test_list), len(valid_paths))
    self.assertTrue(all(candidate.is_valid() for candidate in manager.test_list))
    reporter.write_total_discovered_tests.assert_called_once()
    total, failed_tests = reporter.write_total_discovered_tests.call_args.args
    self.assertEqual(total, len(valid_paths))
    self.assertEqual({candidate.test_path for candidate in failed_tests}, invalid_paths)
    self.assertEqual(len(failed_tests), len(invalid_paths))
    for candidate in failed_tests:
      with self.subTest(test_path=candidate.test_path):
        self.assertIsNone(candidate.to_dict()['name'])
        self.assertFalse(candidate.is_valid())
        self.assertEqual(candidate.result, TestResult.ERRORED)
        self.assertIn('Not valid test', candidate.compile_log)
        self.assertIn('Not valid test', candidate.execute_log)
