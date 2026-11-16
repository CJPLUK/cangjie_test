# Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
# 
# See https://cangjie-lang.cn/pages/LICENSE for license information.

# coding: utf-8
import subprocess
import sys
import re
import os
import time

import json
import urllib.parse
import configparser

# 等待log文件写完之后再读取
wait_log_time = 1


class RunTestcase:

    def __init__(self):
        self.platform = 0
        self.bash = "cmd.exe"
        self.bash_param = "/c"
        self.check_platform()
        self.server_path_dict = {}
        self.info_file_path = sys.argv[1]
        self.section_name = 'lsp_server'
        self.config_file_name = 'lsp_config.txt'
        self.request_key = ["uri", "rootPath", "rootUri", "path_option"]
        self.response_key = ["uri", "rootPath", "rootUri", "code"]
        self.message_label = "Content-Length"
        self.error_key = []
        self.request_list = []
        self.ignore_key = ["jsonrpc", "sortText", "symbolId", "category", "code", "codeActions"]
        # TODO：动态获取排序忽略的key
        self.ignore_sort_key = ["range", "data", 'to', 'fromRanges', 'end', 'start', 'selectionRange', 'children',
                                'additionalTextEdits', 'edits', 'textDocument', 'parameters', 'location', "sortText",
                                "containerName", "symbolId", "codeActions", "category", "code"]
        self.wait_request = ["textDocument/prepareTypeHierarchy", "textDocument/prepareCallHierarchy"]
        self.wait_response_key = {
            "textDocument/prepareTypeHierarchy": "symbolId",
            "textDocument/prepareCallHierarchy": "symbolId",
        }
        self.replace_symbolid_method = {
            "typeHierarchy/subtypes": "symbolId",
            "typeHierarchy/supertypes": "symbolId",
            "callHierarchy/outgoingCalls": "symbolId",
            "callHierarchy/incomingCalls": "symbolId"
        }
        self.request_key_length = {
        }
        self.ignore_uri = ["file:compress",
                           "file:stdx",
                           "file:std"
                           ]
        self.ignore_case_key_for_win = ["uri", "detail"]

    def execute_testcase(self):
        """
        用例执行入口
        :return:
        """
        request_dict, response_dict = self.parse_testcase()
        self.write_request_file(request_dict)
        self.get_lsp_path()
        res_index = self.execute_command()
        act_res_list = self.read_response_file()
        print(act_res_list)
        id_res_dict, no_id_res_list = self.split_response_list(act_res_list)

        wrong_expected_list = []
        compare_file_handle = open("compare_result.txt", encoding="utf-8", mode="a+")

        for each_expected in response_dict:
            self.error_key = []
            each_expected = json.loads(each_expected)
            if "id" in each_expected:
                current_id = int(each_expected["id"])
                if current_id in id_res_dict:
                    self.json_compare(act_res_list[id_res_dict[current_id]], each_expected, "")
                    if not self.error_key:
                        res_index = 0
                    else:
                        res_index = 1
                        wrong_expected_list.append(each_expected)
                    self.write_compare_log(compare_file_handle, res_index, each_expected,
                                           act_res_list[id_res_dict[current_id]])
                else:
                    res_index = 1
                    wrong_expected_list.append(each_expected)
                    self.write_compare_log(compare_file_handle, res_index, each_expected, "")

            else:
                if not no_id_res_list:
                    res_index = 1
                    self.write_msg(compare_file_handle, "no id response message")
                    wrong_expected_list.append(each_expected)
                else:
                    self.error_key = []
                    self.json_compare(no_id_res_list[-1], each_expected, "")
                    if not self.error_key:
                        res_index = 0
                    else:
                        wrong_expected_list.append(each_expected)
                        res_index = 1
                    self.write_compare_log(compare_file_handle, res_index, each_expected, no_id_res_list[-1])
        self.final_result(compare_file_handle, res_index)

    def final_result(self, file_handle, res_index):
        """
        检查用例执行最终情况，打印日志，杀掉进程
        :param file_handle: 日志文件句柄
        :param res_index: 执行结果返回码
        :return:
        """
        final_info = "Sorry! testcase fail." if res_index else "Congratulations! testcase pass!"
        self.write_msg(file_handle, final_info, use_placeholder=True)
        self.write_msg(file_handle, "log is collected in compare_result.txt.")
        env_info = os.getenv('CANGJIE_STDX_PATH')
        self.write_msg(file_handle, 'CANGJIE_STDX_PATH is : ' + env_info)
        file_handle.close()
        if res_index:
            os._exit(1)

    def write_compare_log(self, file_handle, res_index, expect_json, receive_json, is_crash=False):
        """
        将期望结果与实际结果写入compare_result.txt文件
        :param file_handle: 日志文件句柄
        :param res_index: 执行结果返回码
        :param expect_json: 期望结果json串
        :param receive_json: 实际结果json串
        :param is_crash: 执行过程是否崩溃
        :return:
        """
        result_msg = "compare fail" if res_index else "compare succ"
        self.write_msg(file_handle, result_msg, use_placeholder=True)
        self.write_msg(file_handle, "expected message:")
        self.write_msg(file_handle, expect_json, is_json=True)
        self.write_msg(file_handle, "receive message:")
        if not is_crash:
            self.write_msg(file_handle, receive_json, is_json=True)
        else:
            self.write_msg(file_handle, "each_expected id not in receive message,maybe crash.")

    def json_compare(self, recv_data, expected_data, key):
        """
        比较两个 json 格式的数据是否一致
        :param recv_data: 实际结果数据
        :param expected_data: 期望结果数据
        :param key: key值
        :return:
        """

        if isinstance(recv_data, dict):
            for key in expected_data:
                if key not in recv_data:
                    self.error_key.append(key)

            for key in recv_data:
                if key in expected_data:
                    self.json_compare(recv_data[key], expected_data[key], key)
                else:
                    self.error_key.append(key)

        elif isinstance(recv_data, list):
            if recv_data == [] and expected_data == []:
                pass
            elif len(recv_data) != len(expected_data):
                self.error_key.append(key)
            else:
                recv_all_keys, recv_json = self.json_patch(recv_data)
                recv_all_keys = list(set(recv_all_keys) - set(recv_all_keys).intersection(set(self.ignore_sort_key)))
                recv_all_keys = sorted(recv_all_keys)
                expt_all_keys, expected_json = self.json_patch(expected_data)
                expt_all_keys = list(set(expt_all_keys) - set(expt_all_keys).intersection(set(self.ignore_sort_key)))
                expt_all_keys = sorted(expt_all_keys)
                if len(recv_all_keys) > 0:
                    recv_json = sorted(recv_json, key=self.get_json_sort_key)
                if len(expt_all_keys) > 0:
                    expected_json = sorted(expected_json, key=self.get_json_sort_key)

                for src_list, dst_list in zip(recv_json, expected_json):
                    self.json_compare(src_list, dst_list, key)
        else:
            if key in self.ignore_key:
                return
            recv_str = str(recv_data)
            expc_str = str(expected_data)
            if recv_str == expc_str:
                return
            if not self.platform and "\r\n" in recv_str:
                recv_str = recv_str.replace("\r\n", "\n")
            # 处理win环境文件名大小写不区分的逻辑
            if not self.platform and key in self.ignore_case_key_for_win:
                recv_str = recv_str.lower()
                expc_str = expc_str.lower()
            # 处理由于时序导致root包名读取不到的逻辑
            if recv_str != expc_str and "default." in expc_str:
                expc_str = expc_str.replace("default.", "")
            # 处理使用cjvm后端时标准库文件带_cjvm后缀的逻辑
            if recv_str != expc_str and "_cjvm.cj\n" in recv_str:
                recv_str = recv_str.replace("_cjvm.cj\n", ".cj\n")
            if recv_str != expc_str:
                self.error_key.append(key)

    def json_patch(self, list_json):
        """
        获取list里json数据的key并集，并对缺少key的结构体进行补全
        :param list_json: json串中的key对应的列表value
        :return : all_keys 列表中字典的所有key值；list_json 补全后的list
        """
        all_keys = []
        for i in list_json:
            if not isinstance(i, dict):
                break
            all_keys += sorted(i.keys())
        all_keys = sorted(set(all_keys))
        for each_json in list_json:
            if not isinstance(each_json, dict):
                break
            this_keys = sorted(each_json.keys())
            for key in all_keys:
                if key not in this_keys:
                    each_json[key] = "##"
        return all_keys, list_json

    def get_json_sort_key(self, json_object):
        """
        Sort by the comparable part of JSON only.
        """
        return json.dumps(self.remove_ignore_sort_key(json_object), sort_keys=True)

    def remove_ignore_sort_key(self, json_object):
        if isinstance(json_object, dict):
            return {
                key: self.remove_ignore_sort_key(value)
                for key, value in json_object.items()
                if key not in self.ignore_sort_key
            }
        if isinstance(json_object, list):
            return [self.remove_ignore_sort_key(value) for value in json_object]
        return json_object

    def write_msg(self, file_handle, message, is_json=False, use_placeholder=False):
        """
        将日志写入文件中，同时打印输出到控制台
        :param file_handle: 日志文件句柄
        :param message: 具体日志信息
        :param is_json: message是否为json串，默认值为False
        :param use_placeholder: message是否需要占位符补全长度，默认值为False
        :return:
        """
        if is_json:
            message = json.dumps(message, separators=(',', ': '), ensure_ascii=False)
        if use_placeholder:
            message = f'{message:-^120}'
        file_handle.write(message)
        line_break = '\n' if self.platform else '\r\n'
        file_handle.write(line_break)
        print(message)

    def split_response_list(self, res_list):
        """
        分离有无id字段的json串，将有id的json在数组中的位置与id值组合形成字典，无id的json存入另一个数组
        :param res_list: 结果列表
        :return: id_response_dict 有id的返回报文字典；no_id_response_list 无id的返回报文列表
        """
        id_response_dict = {}
        no_id_response_list = []
        for index, resp_json in enumerate(res_list):
            if 'id' in resp_json:
                id_response_dict[int(resp_json['id'])] = index
            else:
                no_id_response_list.append(resp_json)
        return id_response_dict, no_id_response_list

    def read_response_file(self):
        """
        从freopen.out文件中读取服务端返回的json串
        :return: act_res_list 返回结果列表
        """
        act_res_list = []
        try:
            if not os.path.getsize('freopen.out'):
                print('maybe crush')
                return act_res_list
            f_log = open('freopen.out', encoding='utf-8', mode='r')
            out_lint = f_log.readline()
            while out_lint:
                try:
                    res_content = out_lint.split(self.message_label)[0]
                    match = re.match(r'^({.*})', res_content)
                    if match:
                        res_content = match.group(1)
                    act_res_list.append(json.loads(res_content))
                except:
                    pass
                out_lint = f_log.readline()
            f_log.close()
        except FileNotFoundError:
            print('maybe stuck')
        return act_res_list

    def get_symbolid(self, search_key):
        """
        获取 symbolid
        :param search_key: 匹配关键字
        :return: symbolid
        """
        start_time = time.time()
        symbol_id_value = None
        while True:
            time.sleep(0.5)
            try:
                log_f = open('log.txt', 'r')
                msg_list = log_f.readlines()
                log_f.close()
            except FileNotFoundError:
                # 检查是否超过15秒  
                if time.time() - start_time > 15:
                    raise FileNotFoundError("log.txt 文件未找到，已超过15秒。")  # 抛出异常  
                continue  # 如果文件未找到，继续循环

            for line in msg_list[::-1]:
                if search_key in line:
                    symid_pattern = rf'"{search_key}"\s*:\s*"([^"]+)"'
                    match = re.search(symid_pattern, line)
                    if match:
                        symbol_id_value = match.group(1)  # 提取匹配的数字
                        break
            if time.time() - start_time > 15 or symbol_id_value:
                break
        return symbol_id_value

    def replace_symbolid(self, src_request, pattern, symbol_id_value):
        """
        替换请求报文中的 symbolid
        :param src_request: 原始请求报文
        :param pattern: 匹配模式
        :param symbol_id_value: symbolid实际值
        :return: 替换后的请求报文
        """
        new_request = re.sub(pattern, lambda match: f'{match.group(1)}{symbol_id_value}{match.group(2)}', src_request)
        return new_request

    def execute_command(self):
        """
        Reads requests from the freopen.in file line by line and sends them to the server.
        Writes the response to the freopen.out file.
        :return: res_index - execution result code; process_server - server process
        """
        if self.platform:
            lsp_server_path = self.server_path_dict["linux_path"]
        else:
            lsp_server_path = self.server_path_dict["win_path"]
        if self.platform == 2:
            cj_home = lsp_server_path.rsplit('/', 2)[0]
            server_start = f'source {cj_home}/envsetup.sh && {lsp_server_path}/LSPServer --test --disableAutoImport --enable-log=true'
        else:
            server_start = f'{lsp_server_path}/LSPServer --test --disableAutoImport --enable-log=true'
        print(server_start)
        f_out = open('freopen.out', 'w')
        process_server = subprocess.Popen(
            [self.bash, self.bash_param, server_start],
            stdin=subprocess.PIPE,
            stdout=f_out,
            stderr=f_out,
            text=True  # 使用文本模式
        )

        try:
            symbol_id_key = None
            symbol_id_value = None
            for request in self.request_list:
                placeholder = rf'("{symbol_id_key}"\s*:\s*"?)0("?)'
                if symbol_id_value and re.search(placeholder, request):
                    request = self.replace_symbolid(request, placeholder, symbol_id_value)
                    match = re.search(r"Content-Length:(\d+)", request)
                    original_length = int(match.group(1))
                    request = re.sub(r"Content-Length:\d+", f"Content-Length:{original_length + len(symbol_id_value)}",
                                     request)
                process_server.stdin.write(request)
                process_server.stdin.flush()  # 确保输入被发送
                time.sleep(1)
                for request_method in self.wait_request:
                    if request_method in request:
                        symbol_id_key = self.wait_response_key[request_method]
                        symbol_id_value = self.get_symbolid(symbol_id_key)
            time.sleep(1)
            process_server.wait(timeout=30)
        except subprocess.TimeoutExpired as e:
            process_server.kill()
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
        time.sleep(1)
        f_out.close()
        res_index = process_server.returncode
        return res_index

    def write_request_file(self, request_dict):
        """
        输出freopen.in文件
        :param request_dict:
        :return:
        """
        if self.platform:
            line_break = '\n\n'
        else:
            line_break = '\r\n\r\n'
        with open('freopen.in', 'a+', encoding='utf-8') as f_in:
            for each_req in request_dict:
                req = 'Content-Length:' + str(self.calculate_length(each_req)) + line_break + each_req + line_break
                f_in.write(req)
                self.request_list.append(req)

    def check_platform(self):
        """
        获取执行用例的系统平台
        :return:
        """
        if sys.platform == 'linux':
            self.platform = 1
        elif sys.platform == 'darwin':
            self.platform = 2
        if self.platform:
            self.bash = "/bin/bash"
            self.bash_param = "-c"

    def get_lsp_path(self):
        """
        去读lsp_config.txt配置文件内容，获取LSPServer的路径
        :return:
        """
        lsp_config = configparser.ConfigParser()
        lsp_config.read(self.config_file_name, encoding='utf-8')
        self.server_path_dict = {k: v for k, v in lsp_config.items(self.section_name)}

    def get_uri_path(self, path):
        uri_path = urllib.parse.quote(os.path.abspath(path).replace("\\", '/'))
        uri_path = uri_path[0].lower() + uri_path[1:]
        if self.platform:
            uri_path = "file://" + uri_path
        else:
            uri_path = "file:///" + uri_path
        return uri_path

    def replace_changes_uri_key(self, json_object):
        """
        将"changes"中key值换成绝对路径的uri，与uri补齐逻辑一致
        """
        old_keys = list(json_object.keys())
        for key in old_keys:
            if self.include_ignore_uri(key):
                continue
            if key.startswith("file://"):
                decoded_path = urllib.parse.unquote(key[7:] if self.platform else key[8:])
                uri_path = self.get_uri_path(decoded_path)
            else:
                uri_path = urllib.parse.quote(os.path.abspath(key).replace("\\", '/'))
                uri_path = uri_path[0].lower() + uri_path[1:]
                if self.platform:
                    uri_path = "file://" + uri_path
                else:
                    uri_path = "file:///" + uri_path
            json_object[uri_path] = json_object.pop(key)

    def get_multi_module_option(self, json_object):
        """
        将"multiModuleOption"中key值换成绝对路径的uri
        """
        old_keys = list(json_object.keys())
        for key in old_keys:
            uri_path = self.get_uri_path(key)
            json_object[uri_path] = json_object.pop(key)

    def modify_json_key(self, json_object, search_key):
        """
        报文中的值进行处理，如相对路径绝对化
        :param json_object: json对象
        :param search_key: 需要处理的key的列表
        :return: 处理后的json_object
        """
        if isinstance(json_object, dict) and 'multiModuleOption' in json_object:
            self.get_multi_module_option(json_object['multiModuleOption'])
        key_value_iter = ()
        if isinstance(json_object, dict):
            if 'changes' in json_object:
                self.replace_changes_uri_key(json_object['changes'])
            key_value_iter = (x for x in json_object.items())
        elif isinstance(json_object, list):
            key_value_iter = (x for x in enumerate(json_object))
        for key, value in key_value_iter:
            if key in search_key:
                if key == "rootPath":
                    json_object[key] = os.path.abspath(json_object[key]).replace("\\", '/')
                if (key == "rootUri" or key == "uri") and not self.include_ignore_uri(json_object[key]):
                    uri_path = urllib.parse.quote(os.path.abspath(json_object[key]).replace("\\", '/'))
                    uri_path = uri_path[0].lower() + uri_path[1:]
                    if self.platform:
                        json_object[key] = "file://" + uri_path
                    else:
                        json_object[key] = "file:///" + uri_path
                if key == "path_option" and isinstance(value, list):
                    path_list = json_object[key]
                    for i in range(len(path_list)):
                        if path_list[i] == "${CANGJIE_STDX_PATH}":
                            env_info = os.getenv('CANGJIE_STDX_PATH')
                            if isinstance(env_info, str):
                                path_list[i] = self.get_uri_path(env_info)

            if isinstance(value, (dict, list)):
                self.modify_json_key(value, search_key)
        return json.dumps(json_object, separators=(',', ':'))

    def include_ignore_uri(self, uri):
        for item in self.ignore_uri:
            if item in uri:
                return True
        return False

    def parse_testcase(self):
        """
        从预期文件中提取request及response
        :return: request_dict 原始请求字典；response_dict 原始回复字典
        """
        tf = open(self.info_file_path, encoding='utf-8')
        expected_content = tf.read()
        tf.close()
        expected_content = list(filter(None, re.split('Req#\n|Rev#\n', expected_content)))
        request_dict = list(filter(None, expected_content[1].split('\n')))
        response_dict = list(filter(None, expected_content[2].split('\n')))
        try:
            os.remove("freopen.in")
        except:
            pass
        for i in range(len(request_dict)):
            req_json = json.loads(request_dict[i])
            request_dict[i] = self.modify_json_key(req_json, self.request_key)

        for i in range(len(response_dict)):
            res_json = json.loads(response_dict[i])
            response_dict[i] = self.modify_json_key(res_json, self.response_key)

        return request_dict, response_dict

    def calculate_length(self, each_req):
        length = 0
        for key, value in self.request_key_length.items():
            if f'"{key}"' in each_req:
                length += value
        return length + len(each_req)


if __name__ == "__main__":
    lsp_case = RunTestcase()
    lsp_case.execute_testcase()
