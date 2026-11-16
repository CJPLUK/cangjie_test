// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

/**
 * Created on 2024/2/27
 */
package search

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import bean.BaseDataSource
import ohos.router.*
import std.collection.*
import appres.*

@Entry
@Component
public class SearchPage {
    override func render() {
        Column() {
            Row() {
                Image(@r(app.media.ic_arrow_left)).width(24).height(24).onClick {e => Router.back()}
                TextInput(placeholder: "请输入搜索内容").height(36).layoutWeight(1).margin(left: 12)
                    .backgroundColor(CC.grey6)
                Text("取消").margin(left: 20)
            }.width(100.percent).padding(left: 16, right: 16)
            List() {
                LazyForEach(
                    getListDataSource(),
                    itemGeneratorFunc: {
                        item: SearchQuestionItemBean, index => ListItem() {
                            Row() {
                                Image(@r(app.media.ic_search_problem)).width(20).height(20)
                                Text(item.title).margin(left: 12).fontSize(15.fp).fontColor(CC.label_primary)
                                    .fontWeight(FontWeight.Bold).maxLines(1).textOverflow(TextOverflow.Ellipsis)
                            }.width(100.percent).height(50).padding(left: 20, right: 20)
                        }.onClick({
                            e => Router.push(url: "QuestionDetailPage",
                                //params: JsonObject(HashMap<String, JsonValue>([("data", JsonString(item.title))]))
                            )
                        })
                    }
                )
            }.margin(top: 20)
        }.width(100.percent).height(100.percent).backgroundColor(CC.paper)
    }

    func getListDataSource() {
        return SearchQuestionListDataSource(
            ArrayList<SearchQuestionItemBean>(
                [SearchQuestionItemBean("1.两数之和", false), SearchQuestionItemBean("1.两数之和", false),
                    SearchQuestionItemBean("1.两数之和", false), SearchQuestionItemBean("1.两数之和", false)]))
    }
}

class SearchQuestionItemBean {
    public SearchQuestionItemBean(let title: String, let isVip: Bool) {}
}

class SearchQuestionListDataSource <: BaseDataSource<SearchQuestionItemBean> {
    public SearchQuestionListDataSource(var datas: ArrayList<SearchQuestionItemBean>) {
        super(datas)
    }
}

public class WithinArray {
    public var set_string_top1: HashSet<String> = HashSet<String>(
        ["`~!@#$%^&*()_+-=[{}]\\|:;'\",./? %……&*（）+-={}【】、|：；‘“”“，。、？", "collection_HashSet"])
    public var set_string_top1: HashSet<String> = HashSet<String>(
        ["`~!@#$%^&*()_+-=[{}]\\|:;'\",./? %……&*（）+-={}【】、|：；‘“”“，。、？", "collection_HashSet"])

    public var arrayInt64_p: Array<Array<Array<Array<Array<Int64>>>>> = Array<Array<Array<Array<Array<Int64>>>>>(2,
        item: arrayInt64_q) //5维
    public var arrayInt64_p_1: Array<Array<Array<Array<Array<Int64>>>>> = Array<Array<Array<Array<Array<Int64>>>>>(2,
        item: arrayInt64_q) //5维
}
