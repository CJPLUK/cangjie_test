# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

'''
File: base_test.py

Description:
Implemented base class for tests
'''

import re
import enum
import logging

from os import path


class TestRunMode(str, enum.Enum):
  '''Test run mode enum'''
  run = 'run'
  compilationOnly = 'compileonly'


class TestResult(str, enum.Enum):
  '''Test results enum'''
  PENDING = 'PENDING'
  PASSED = 'PASSED'
  FAILED = 'FAILED'
  ERRORED = 'ERRORED'
  SKIPPED = 'SKIPPED'
  INCOMPLETE = 'INCOMPLETE'


class WarningExpect(str, enum.Enum):
  '''Test warnings enum'''
  NO = 'no'
  YES = 'yes'
  IGNORE = 'ignore'


class BaseTest:
  '''Implemented base class for test'''
  _DEFAULT_ASSERTION = ''
  _DEFAULT_DESCRIPTION = ''
  _DEFAULT_MODE = TestRunMode.run
  _DEFAULT_NEGATIVE = False
  _DEFAULT_COMPILE_WARNING = WarningExpect.NO
  _DEFAULT_REPLAYED = False
  _DEFAULT_EXPECT_TIMEOUT = False
  _DEFAULT_TIMEOUT_FACTOR = 1.0
  _DEFAULT_COMMENT = ''
  _DEFAULT_RESULT = TestResult.PENDING
  _DEFAULT_BIN_PATH = ''
  _DEFAULT_COMPILE_TIME = -1.0
  _DEFAULT_EXECUTE_TIME = -1.0
  _DEFAULT_ISSUE = ''
  _DEFAULT_LEVEL = ''

  # Message constants
  ICE_MSG = 'Internal Compiler Error'.lower()
  WARNING_MSG = 'warning:'
  TIMEOUT_MSG = 'timeout has expired'

  def __init__(self, test_path: str) -> None:
    # Instance attributes
    self._test_path = None
    self._name = None
    self._assertion = None
    self._description = None
    self._mode = None
    self._is_negative = None
    self._compile_warning = None
    self._is_replayed = None
    self._expect_timeout = None
    self._timeout_factor = None
    self._comment = None
    self._compile_log = ''
    self._execute_log = ''
    self._binary_path = None
    self._result = None
    self._compile_time = None
    self._execute_time = None
    self._compile_start = None
    self._execute_start = None
    self._compile_stop = None
    self._execute_stop = None
    self._comp_worker_pid = None
    self._exec_worker_pid = None
    self._issue = None
    self._level = None

    # Property
    self.test_path = test_path

    if not self.test_path:
      return

    # Get test source
    with open(self.test_path, 'r', encoding='utf-8') as src:
      self._source = src.read().splitlines()

    self.name = self._get_attribute('name')
    self.assertion = self._get_attribute('assertion')
    self.description = self._get_attribute('description')
    self.mode = self._get_attribute('mode')
    self.is_negative = self._get_attribute('negative')
    self.compile_warning = self._get_attribute('compilewarning')
    self.is_replayed = self._has_attribute('replay')
    self.expect_timeout = self._has_attribute('expecttimeout')
    self.timeout_factor = self._get_attribute('timeoutfactor')
    self.comment = self._get_attribute('comment')
    self.issue = self._get_attribute('issue')
    self.level = self._get_attribute('level')

  def _get_attribute(self, attr: str) -> str:
    in_field = False
    for line in self._source:
      line = line.strip()
      if line.lower().startswith('@' + attr.lower() + ':'):
        # Split first line of field
        in_field = True
        value = line[len(attr) + 2:].strip() + '\n'
      elif in_field:
        # Check the end of field
        if line.startswith('@') or line.startswith('*/') or not line:
          return value.strip()
        else:
          # Append the multi-line to value
          value += line + '\n'
    return None

  def _has_attribute(self, attr: str) -> bool:
    for line in self._source:
      line = line.strip()
      if line.lower() == str('@' + attr.lower()):
        return True
    return False

  def is_valid(self) -> bool:
    '''Validate test'''
    if self._test_path is None:
      return False
    if self._name is None:
      return False
    if not isinstance(self._mode, TestRunMode):
      return False
    if not isinstance(self._is_negative, bool):
      return False
    if not isinstance(self._compile_warning, WarningExpect):
      return False
    return True

  @property
  def _logger(self):
    return logging.getLogger(__name__)

  def _log_debug_about_default_value(self, prop_name: str, default_value: any) -> None:
    self._logger.debug('The %s property wasn\'t set. Use the default value: %s', prop_name, default_value)

  def _log_debug_property_value(self, prop_name: str, value: any) -> None:
    self._logger.debug('The %s property is: %s', prop_name, value)

  def _log_error_about_second_set_value(self, prop_name: str) -> None:
    self._logger.error('Value of the %s property couldn\'t set a second time.', prop_name)

  def to_dict(self) -> dict:
    '''Convert BaseTest to dictionary'''
    result = {
        'name': self._name,
        'test_path': self._test_path,
        'assertion': self._assertion,
        'description': self._description,
        'mode': self._mode,
        'is_negative': self._is_negative,
        'compile_warning': self._compile_warning,
        'is_replayed': self._is_replayed,
        'expect_timeout': self._expect_timeout,
        'timeout_factor': self._timeout_factor,
        'comment': self._comment,
        'compile_log': self._compile_log,
        'execute_log': self._execute_log,
        'binary_path': self._binary_path,
        'result': self._result,
        'compile_time': self._compile_time,
        'compile_start': self._compile_start,
        'compile_stop': self._compile_stop,
        'comp_worker_pid': self._comp_worker_pid,
        'execute_time': self._execute_time,
        'execute_start': self._execute_start,
        'execute_stop': self._execute_stop,
        'exec_worker_pid': self._exec_worker_pid,
        'issue': self._issue,
        'level': self._level
    }
    return result

  def __str__(self):
    return str(self.to_dict())

  @property
  def test_path(self) -> str:
    '''Path to the test file'''
    return self._test_path

  @test_path.setter
  def test_path(self, value: str) -> None:
    if value is None:
      self._logger.error('The path to the test is empty. Skip.')
      return
    if self._test_path is None:
      abs_path = path.abspath(value)
      if path.isfile(abs_path):
        self._test_path = abs_path
        self._log_debug_property_value('test_path', self._test_path)
      else:
        self._logger.error('Incorrect path `%s` to the test. Skip.', value)
    else:
      self._log_error_about_second_set_value('test_path')

  @property
  def name(self) -> str:
    '''Test name'''
    if self._name is None:
      default_test_name = '.'.join(path.basename(self.test_path).split('.')[:-1])
      self._log_debug_about_default_value('name', default_test_name)
      self.name = default_test_name
    return self._name

  @name.setter
  def name(self, value: str) -> None:
    if value is None:
      value = '.'.join(path.basename(self.test_path).split('.')[:-1])
      self._log_debug_about_default_value('name', value)
    # Reject illegal characters anywhere in the test name.
    if not re.search(r'[<>:"/\\|?*\x00]', value):
      self._name = value
      self._log_debug_property_value('name', self._name)
    else:
      self._logger.error('Incorrect value `%s` of @Name attribute in test `%s`', value, self.test_path)

  @property
  def assertion(self) -> str:
    '''Number and text of the assertion that corresponds to the test'''
    if self._assertion is None:
      self._log_debug_about_default_value('assert_desc', self._DEFAULT_ASSERTION)
      self.assertion = self._DEFAULT_ASSERTION
    return self._assertion

  @assertion.setter
  def assertion(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('assertion', self._DEFAULT_ASSERTION)
      value = self._DEFAULT_ASSERTION
    if self._assertion is None:
      self._assertion = value
      self._log_debug_property_value('assertion', self._assertion)
    else:
      self._log_error_about_second_set_value('assertion')

  @property
  def description(self) -> str:
    '''Test case description as part of the assertion'''
    if self._description is None:
      self._log_debug_about_default_value('test_desc', self._DEFAULT_DESCRIPTION)
      self.description = self._DEFAULT_DESCRIPTION
    return self._description

  @description.setter
  def description(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('test_desc', self._DEFAULT_DESCRIPTION)
      value = self._DEFAULT_DESCRIPTION
    if self._description is None:
      self._description = value
      self._log_debug_property_value('test_desc', self._description)
    else:
      self._log_error_about_second_set_value('test_desc')

  @property
  def mode(self) -> TestRunMode:
    '''Mode of test execution. Usually mixed'''
    if self._mode is None:
      self._log_debug_about_default_value('mode', self._DEFAULT_MODE)
      self.mode = self._DEFAULT_MODE
    return TestRunMode(self._mode)

  @mode.setter
  def mode(self, value: any) -> None:
    if value is None:
      self._log_debug_about_default_value('mode', self._DEFAULT_MODE)
      value = self._DEFAULT_MODE
    if self._mode is None:
      if isinstance(value, str):
        try:
          self._mode = TestRunMode(value.lower())
        except ValueError:
          self._logger.error('Incorrect value `%s` of @Mode attribute in test `%s`', value, self._name)
      elif isinstance(value, TestRunMode):
        self._mode = value
      else:
        self._logger.error('Incorrect value `%s` of @Mode attribute in test `%s`', value, self._name)
      self._log_debug_property_value('mode', self._mode)
    else:
      self._log_error_about_second_set_value('mode')

  @property
  def is_negative(self) -> bool:
    '''Whether a test case is negative. Usually false'''
    if self._is_negative is None:
      self._log_debug_about_default_value('is_negative', self._DEFAULT_NEGATIVE)
      self.is_negative = self._DEFAULT_NEGATIVE
    return bool(self._is_negative)

  @is_negative.setter
  def is_negative(self, value: any) -> None:
    if value is None:
      self._log_debug_about_default_value('is_negative', self._DEFAULT_NEGATIVE)
      value = self._DEFAULT_NEGATIVE
    if self._is_negative is None:
      if isinstance(value, bool):
        self._is_negative = value
      elif isinstance(value, str):
        if value.lower() == 'yes' or value.lower() == 'no':
          self._is_negative = bool(value.lower() == 'yes')
        else:
          self._logger.error('Incorrect value `%s` of @Negative attribute in test `%s`', value, self._name)
      else:
        self._logger.error('Incorrect value `%s` of @Negative attribute in test `%s`', value, self._name)
      self._log_debug_property_value('is_negative', self._is_negative)
    else:
      self._log_error_about_second_set_value('is_negative')

  @property
  def compile_warning(self) -> WarningExpect:
    '''Whether the test is expected to crash with compile warnings. Usually no'''
    if self._compile_warning is None:
      self._log_debug_about_default_value('compile_warning', self._DEFAULT_COMPILE_WARNING)
      self.compile_warning = self._DEFAULT_COMPILE_WARNING
    return WarningExpect(self._compile_warning)

  @compile_warning.setter
  def compile_warning(self, value: bool) -> None:
    if value is None:
      self._log_debug_about_default_value('compile_warning', self._DEFAULT_COMPILE_WARNING)
      value = self._DEFAULT_COMPILE_WARNING
    if self._compile_warning is None:
      if isinstance(value, str):
        try:
          self._compile_warning = WarningExpect(value.lower())
        except ValueError:
          self._logger.error('Incorrect value `%s` of @CompileWarning attribute in test `%s`', value, self._name)
      elif isinstance(value, WarningExpect):
        self._compile_warning = value
      else:
        self._logger.error('Incorrect value `%s` of @CompileWarning attribute in test `%s`', value, self._name)
      self._log_debug_property_value('compile_warning', self._compile_warning)
    else:
      self._log_error_about_second_set_value('compile_warning')

  @property
  def is_replayed(self) -> bool:
    '''Whether a test case is replayed. Usually false'''
    if self._is_replayed is None:
      self._log_debug_about_default_value('is_replayed', self._DEFAULT_REPLAYED)
      self.is_replayed = self._DEFAULT_REPLAYED
    return bool(self._is_replayed)

  @is_replayed.setter
  def is_replayed(self, value: bool) -> None:
    if value is None:
      self._log_debug_about_default_value('is_replayed', self._DEFAULT_REPLAYED)
      value = self._DEFAULT_REPLAYED
    if self._is_replayed is None:
      self._is_replayed = value
      self._log_debug_property_value('is_replayed', self._is_replayed)
    else:
      self._log_error_about_second_set_value('is_replayed')

  @property
  def expect_timeout(self) -> bool:
    '''Whether the test is expected to crash by timeout. Usually false'''
    if self._expect_timeout is None:
      self._log_debug_about_default_value('expect_timeout', self._DEFAULT_EXPECT_TIMEOUT)
      self.expect_timeout = self._DEFAULT_EXPECT_TIMEOUT
    return bool(self._expect_timeout)

  @expect_timeout.setter
  def expect_timeout(self, value: bool) -> None:
    if value is None:
      self._log_debug_about_default_value('expect_timeout', self._DEFAULT_EXPECT_TIMEOUT)
      value = self._DEFAULT_EXPECT_TIMEOUT
    if self._expect_timeout is None:
      self._expect_timeout = bool(value)
      self._log_debug_property_value('expect_timeout', self._expect_timeout)
    else:
      self._log_error_about_second_set_value('expect_timeout')

  @property
  def timeout_factor(self) -> float:
    '''Optional test timeout factor, Usually 1.0'''
    if self._timeout_factor is None:
      self._log_debug_about_default_value('timeout_factor', self._DEFAULT_TIMEOUT_FACTOR)
      self.timeout_factor = self._DEFAULT_TIMEOUT_FACTOR
    return self._timeout_factor

  @timeout_factor.setter
  def timeout_factor(self, value: any) -> None:
    if value is None:
      value = self._DEFAULT_TIMEOUT_FACTOR
      self._log_debug_about_default_value('timeout_factor', value)
    if self._timeout_factor is None:
      try:
        self._timeout_factor = float(value)
        if self._timeout_factor <= 0:
          raise ValueError
      except ValueError:
        self._logger.error('Incorrect value `%s` of @TimeoutFactor attribute in test `%s`', value, self._name)
        self._log_debug_about_default_value('timeout_factor', self._DEFAULT_TIMEOUT_FACTOR)
        self._timeout_factor = self._DEFAULT_TIMEOUT_FACTOR
      self._log_debug_property_value('timeout_factor', self._timeout_factor)
    else:
      self._log_error_about_second_set_value('timeout_factor')

  @property
  def comment(self) -> str:
    '''Optional comment'''
    if self._comment is None:
      self._log_debug_about_default_value('comment', self._DEFAULT_COMMENT)
      self.comment = self._DEFAULT_COMMENT
    return self._comment

  @comment.setter
  def comment(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('comment', self._DEFAULT_COMMENT)
      value = self._DEFAULT_COMMENT
    if self._comment is None:
      self._comment = value
      self._log_debug_property_value('comment', self._comment)
    else:
      self._log_error_about_second_set_value('comment')

  @property
  def compile_log(self) -> str:
    '''Compile completedProcess'''
    return self._compile_log

  @compile_log.setter
  def compile_log(self, value: str) -> None:
    self._compile_log = value
    self._log_debug_property_value('compile_log', self._compile_log)

  @property
  def execute_log(self) -> str:
    '''Execute completedProcess'''
    return self._execute_log

  @execute_log.setter
  def execute_log(self, value: str) -> None:
    self._execute_log = value
    self._log_debug_property_value('execute_res', self._execute_log)

  @property
  def binary_path(self) -> str:
    '''Path to the test binary file'''
    if self._binary_path is None:
      self._log_debug_about_default_value('binary_path', self._DEFAULT_BIN_PATH)
      self.binary_path = self._DEFAULT_BIN_PATH
    return self._binary_path

  @binary_path.setter
  def binary_path(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('binary_path', self._DEFAULT_BIN_PATH)
      value = self._DEFAULT_BIN_PATH
    self._binary_path = value
    self._log_debug_property_value('binary_path', self._binary_path)

  @property
  def result(self) -> TestResult:
    '''Test result'''
    if self._result is None:
      self._log_debug_about_default_value('result', self._DEFAULT_RESULT)
      self._result = self._DEFAULT_RESULT
    return self._result

  @result.setter
  def result(self, value: any) -> None:
    if isinstance(value, str):
      try:
        self._result = TestResult(value.upper())
      except ValueError:
        self._logger.error('Trying to set an unknown test status: %s', value)
    elif isinstance(value, TestResult):
      self._result = value
    else:
      self._logger.error('Trying to set an unknown test status: %s', value)

  @property
  def compile_time(self) -> float:
    '''The compile time'''
    if self._compile_time is None:
      self._log_debug_about_default_value('compile_time', self._DEFAULT_COMPILE_TIME)
      self.compile_time = self._DEFAULT_COMPILE_TIME
    return self._compile_time

  @compile_time.setter
  def compile_time(self, value: float) -> None:
    if value is None:
      self._log_debug_about_default_value('compile_time', self._DEFAULT_COMPILE_TIME)
      value = self._DEFAULT_COMPILE_TIME
    if self._compile_time is None:
      self._compile_time = float(value)
      self._log_debug_property_value('compile_time', self._compile_time)
    else:
      self._log_error_about_second_set_value('compile_time')

  @property
  def execute_time(self) -> float:
    '''The compile time'''
    if self._execute_time is None:
      self._log_debug_about_default_value('execute_time', self._DEFAULT_EXECUTE_TIME)
      self.execute_time = self._DEFAULT_EXECUTE_TIME
    return self._execute_time

  @execute_time.setter
  def execute_time(self, value: float) -> None:
    if value is None:
      self._log_debug_about_default_value('execute_time', self._DEFAULT_EXECUTE_TIME)
      value = self._DEFAULT_EXECUTE_TIME
    if self._execute_time is None:
      self._execute_time = float(value)
      self._log_debug_property_value('execute_time', self._execute_time)
    else:
      self._log_error_about_second_set_value('execute_time')

  @property
  def compile_start(self) -> float:
    '''The compile start'''
    return self._compile_start

  @compile_start.setter
  def compile_start(self, value: float) -> None:
    if value is None:
      return
    if self._compile_start is None:
      self._compile_start = float(value)
      self._log_debug_property_value('compile_start', self._compile_start)
    else:
      self._log_error_about_second_set_value('compile_start')

  @property
  def execute_start(self) -> float:
    '''The execute start'''
    return self._execute_start

  @execute_start.setter
  def execute_start(self, value: float) -> None:
    if value is None:
      return
    if self._execute_start is None:
      self._execute_start = float(value)
      self._log_debug_property_value('execute_start', self._execute_start)
    else:
      self._log_error_about_second_set_value('execute_start')

  @property
  def compile_stop(self) -> float:
    '''The compile stop'''
    return self._compile_stop

  @compile_stop.setter
  def compile_stop(self, value: float) -> None:
    if value is None:
      return
    if self._compile_stop is None:
      self._compile_stop = float(value)
      self._log_debug_property_value('compile_stop', self._compile_stop)
    else:
      self._log_error_about_second_set_value('compile_stop')

  @property
  def execute_stop(self) -> float:
    '''The execute stop'''
    return self._execute_stop

  @execute_stop.setter
  def execute_stop(self, value: float) -> None:
    if value is None:
      return
    if self._execute_stop is None:
      self._execute_stop = float(value)
      self._log_debug_property_value('execute_stop', self._execute_stop)
    else:
      self._log_error_about_second_set_value('execute_stop')

  @property
  def comp_worker_pid(self) -> int:
    '''The execute stop'''
    return self._comp_worker_pid

  @comp_worker_pid.setter
  def comp_worker_pid(self, value: int) -> None:
    if value is None:
      return
    if self._comp_worker_pid is None:
      self._comp_worker_pid = int(value)
      self._log_debug_property_value('comp_worker_pid', self._comp_worker_pid)
    else:
      self._log_error_about_second_set_value('comp_worker_pid')

  @property
  def exec_worker_pid(self) -> int:
    '''The execute stop'''
    return self._exec_worker_pid

  @exec_worker_pid.setter
  def exec_worker_pid(self, value: int) -> None:
    if value is None:
      return
    if self._exec_worker_pid is None:
      self._exec_worker_pid = int(value)
      self._log_debug_property_value('exec_worker_pid', self._exec_worker_pid)
    else:
      self._log_error_about_second_set_value('exec_worker_pid')

  @property
  def issue(self) -> str:
    '''Issue number (optional)'''
    if self._issue is None:
      self._log_debug_about_default_value('issue', self._DEFAULT_ISSUE)
      self.issue = self._DEFAULT_ISSUE
    return self._issue

  @issue.setter
  def issue(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('issue', self._DEFAULT_ISSUE)
      value = self._DEFAULT_ISSUE
    if self._issue is None:
      self._issue = value
      self._log_debug_property_value('issue', self._issue)
    else:
      self._log_error_about_second_set_value('issue')

  @property
  def level(self) -> str:
    '''Level to the tests'''
    if self._level is None:
      self._log_debug_about_default_value('level', self._DEFAULT_LEVEL)
      self.level = self._DEFAULT_LEVEL
    return self._level

  @level.setter
  def level(self, value: str) -> None:
    if value is None:
      self._log_debug_about_default_value('level', self._DEFAULT_LEVEL)
      value = self._DEFAULT_LEVEL
    if self._level is None:
      self._level = value
      self._log_debug_property_value('level', self._level)
    else:
      self._log_error_about_second_set_value('level')
