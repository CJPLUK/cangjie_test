/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// DEPENDENCE: inputs.cj utils.cj visitors.cj
// EXEC: %compiler %cmp_opt -O2 %overflow_wrapping --no-sub-pkg %cmp_utest_opt -Woff=all %f inputs.cj utils.cj visitors.cj -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run %run_opt %output %run_utest_opt %run_args --bench --no-color
// TIMEOUT: 7200

import std.ast.*
import std.collection.*
import std.runtime.*

@Test
@Measure[TimeNow(Nanos)]
class TestVisitBuilderTraverse {

    let visitBuilderForBuilder1 = VisitBuilder(quote(thisView))
    let visitBuilderForBuilder2 = VisitBuilder(quote(thisView))
    let visitBuilderForBuilder3 = VisitBuilder(quote(thisView))
    let visitBuilderForBuilder4 = VisitBuilder(quote(this))
    let visitBuilderForBuilder5 = VisitBuilder(quote(this))
    let visitBuilderForBuilder6 = VisitBuilder(quote(this))
    let visitBuilderForBuilder7 = VisitBuilder(quote(this))
    let visitBuilderForBuilder8 = VisitBuilder(quote(this))
    let visitBuilderForBuilder9 = VisitBuilder(quote(this))
    let visitBuilderForBuilder10 = VisitBuilder(quote(this))

    let builderInput1: Expr
    let builderInput2: Expr
    let builderInput3: Expr
    let customDialogInput1: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput1: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput2: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput3: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput4: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput5: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()
    let componentInput6: ArrayList<ArrayList<Node> > = ArrayList<ArrayList<Node> >()

    TestVisitBuilderTraverse() {
        this.builderInput1 = ((parseDecl(cangjieLex(builderStr1)) as FuncDecl).getOrThrow().block.nodes[0] as Expr).getOrThrow()
        this.builderInput2 = ((parseDecl(cangjieLex(builderStr2)) as FuncDecl).getOrThrow().block.nodes[0] as Expr).getOrThrow()
        this.builderInput3 = ((parseDecl(cangjieLex(builderStr3)) as FuncDecl).getOrThrow().block.nodes[0] as Expr).getOrThrow()
        let d1 = (parseDecl(cangjieLex(customDialogStr1)) as ClassDecl).getOrThrow().body.decls
        for(decl in d1) {
            if (decl is FuncDecl) {
                this.customDialogInput1.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d2 = (parseDecl(cangjieLex(componentStr1)) as ClassDecl).getOrThrow().body.decls
        for(decl in d2) {
            if (decl is FuncDecl) {
                this.componentInput1.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d3 = (parseDecl(cangjieLex(componentStr2)) as ClassDecl).getOrThrow().body.decls
        for(decl in d3) {
            if (decl is FuncDecl) {
                this.componentInput2.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d4 = (parseDecl(cangjieLex(componentStr3)) as ClassDecl).getOrThrow().body.decls
        for(decl in d4) {
            if (decl is FuncDecl) {
                this.componentInput3.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d5 = (parseDecl(cangjieLex(componentStr4)) as ClassDecl).getOrThrow().body.decls
        for(decl in d5) {
            if (decl is FuncDecl) {
                this.componentInput4.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d6 = (parseDecl(cangjieLex(componentStr5)) as ClassDecl).getOrThrow().body.decls
        for(decl in d6) {
            if (decl is FuncDecl) {
                this.componentInput5.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
        let d7 = (parseDecl(cangjieLex(componentStr6)) as ClassDecl).getOrThrow().body.decls
        for(decl in d7) {
            if (decl is FuncDecl) {
                this.componentInput6.add((decl as FuncDecl).getOrThrow().block.nodes)
            }
        }
    }

    // in func bindBuilderCtx
    @Bench 
    func BenchmarkVisitorTraverse_VisitBuilder_001() : Unit {
        blackBox(builderInput1.traverse(visitBuilderForBuilder1))
    }
    @Bench 
    func BenchmarkVisitorTraverse_VisitBuilder_002() : Unit {
        blackBox(builderInput2.traverse(visitBuilderForBuilder2))
    }
    @Bench 
    func BenchmarkVisitorTraverse_VisitBuilder_003() : Unit {
        blackBox(builderInput3.traverse(visitBuilderForBuilder3))
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_004(): Unit {
        for (input in customDialogInput1) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder4))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_005(): Unit {
        for (input in componentInput1) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder5))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_006(): Unit {
        for (input in componentInput2) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder6))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_007(): Unit {
        for (input in componentInput3) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder7))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_008(): Unit {
        for (input in componentInput4) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder8))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_009(): Unit {
        for (input in componentInput5) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder9))
                case _ => ()
            }
        }
        ()
    }
    @Bench
    func BenchmarkVisitorTraverse_VisitBuilder_010(): Unit {
        for (input in componentInput6) {
            match (input[0]) {
                case value: Expr =>
                    blackBox(value.traverse(visitBuilderForBuilder10))
                case _ => ()
            }
        }
        ()
    }
}

@Test
@Measure[TimeNow(Nanos)]
class TestObservedClassInitDeclVisitorTraverse {

    let observedClassInitDeclVisitor = ObservedClassInitDeclVisitor()

    let observedInput1: ClassDecl
    let observedInput2: ClassDecl
    let observedInput3: ClassDecl
    let customDialogInput1: ClassDecl
    let componentInput1: ClassDecl
    let componentInput2: ClassDecl
    let componentInput3: ClassDecl
    let componentInput4: ClassDecl
    let componentInput5: ClassDecl
    let componentInput6: ClassDecl

    TestObservedClassInitDeclVisitorTraverse() {
        this.observedInput1 = (parseDecl(cangjieLex(observedStr1)) as ClassDecl).getOrThrow()
        this.observedInput2 = (parseDecl(cangjieLex(observedStr2)) as ClassDecl).getOrThrow()
        this.observedInput3 = (parseDecl(cangjieLex(observedStr3)) as ClassDecl).getOrThrow()
        this.customDialogInput1 = (parseDecl(cangjieLex(customDialogStr1)) as ClassDecl).getOrThrow()
        this.componentInput1 = (parseDecl(cangjieLex(componentStr1)) as ClassDecl).getOrThrow()
        this.componentInput2 = (parseDecl(cangjieLex(componentStr2)) as ClassDecl).getOrThrow()
        this.componentInput3 = (parseDecl(cangjieLex(componentStr3)) as ClassDecl).getOrThrow()
        this.componentInput4 = (parseDecl(cangjieLex(componentStr4)) as ClassDecl).getOrThrow()
        this.componentInput5 = (parseDecl(cangjieLex(componentStr5)) as ClassDecl).getOrThrow()
        this.componentInput6 = (parseDecl(cangjieLex(componentStr6)) as ClassDecl).getOrThrow()

    }

    // in func checkInitFunc
    @Bench 
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVisitor_001() : Unit {
        blackBox(observedInput1.traverse(observedClassInitDeclVisitor))
    }
    @Bench 
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVisitor_002() : Unit {
        blackBox(observedInput2.traverse(observedClassInitDeclVisitor))
    }
    @Bench 
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVisitor_003() : Unit {
        blackBox(observedInput3.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_004(): Unit {
        blackBox(customDialogInput1.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_005(): Unit {
        blackBox(componentInput1.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_006(): Unit {
        blackBox(componentInput2.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_007(): Unit {
        blackBox(componentInput3.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_008(): Unit {
        blackBox(componentInput4.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_009(): Unit {
        blackBox(componentInput5.traverse(observedClassInitDeclVisitor))
    }
    @Bench
    func BenchmarkVisitorTraverse_ObservedClassInitDeclVistor_010(): Unit {
        blackBox(componentInput6.traverse(observedClassInitDeclVisitor))
    }

}


@Test
@Measure[TimeNow(Nanos)]
class TestComponentVarDeclVisitorTraverse {
    let componentVarDeclVisitor1 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor2 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor3 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor4 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor5 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor6 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor7 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor8 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor9 = ComponentVarDeclVisitor()
    let componentVarDeclVisitor10 = ComponentVarDeclVisitor()

    let observedInput1: ClassDecl
    let observedInput2: ClassDecl
    let observedInput3: ClassDecl
    let customDialogInput1: ClassDecl
    let componentInput1: ClassDecl
    let componentInput2: ClassDecl
    let componentInput3: ClassDecl
    let componentInput4: ClassDecl
    let componentInput5: ClassDecl
    let componentInput6: ClassDecl

    TestComponentVarDeclVisitorTraverse() {
        this.observedInput1 = (parseDecl(cangjieLex(observedStr1)) as ClassDecl).getOrThrow()
        this.observedInput2 = (parseDecl(cangjieLex(observedStr2)) as ClassDecl).getOrThrow()
        this.observedInput3 = (parseDecl(cangjieLex(observedStr3)) as ClassDecl).getOrThrow()
        this.customDialogInput1 = (parseDecl(cangjieLex(customDialogStr1)) as ClassDecl).getOrThrow()
        this.componentInput1 = (parseDecl(cangjieLex(componentStr1)) as ClassDecl).getOrThrow()
        this.componentInput2 = (parseDecl(cangjieLex(componentStr2)) as ClassDecl).getOrThrow()
        this.componentInput3 = (parseDecl(cangjieLex(componentStr3)) as ClassDecl).getOrThrow()
        this.componentInput4 = (parseDecl(cangjieLex(componentStr4)) as ClassDecl).getOrThrow()
        this.componentInput5 = (parseDecl(cangjieLex(componentStr5)) as ClassDecl).getOrThrow()
        this.componentInput6 = (parseDecl(cangjieLex(componentStr6)) as ClassDecl).getOrThrow()

    }

    // in func getVarDecls
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_001() : Unit {
        blackBox(observedInput1.traverse(componentVarDeclVisitor1))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_002() : Unit {
        blackBox(observedInput2.traverse(componentVarDeclVisitor2))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_003() : Unit {
        blackBox(observedInput3.traverse(componentVarDeclVisitor3))
    }

    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_004() : Unit {
        blackBox(customDialogInput1.traverse(componentVarDeclVisitor4))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_005() : Unit {
        blackBox(componentInput1.traverse(componentVarDeclVisitor5))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_006() : Unit {
        blackBox(componentInput2.traverse(componentVarDeclVisitor6))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_007() : Unit {
        blackBox(componentInput3.traverse(componentVarDeclVisitor7))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_008() : Unit {
        blackBox(componentInput4.traverse(componentVarDeclVisitor8))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_009() : Unit {
        blackBox(componentInput5.traverse(componentVarDeclVisitor9))
    }
    @Bench
    func BenchmarkVisitorTraverse_ComponentVarDeclVisitor_010() : Unit {
        blackBox(componentInput6.traverse(componentVarDeclVisitor10))
    }

}


@Test
@Measure[TimeNow(Nanos)]
class TestCustomDialogVarVisitorTraverse {
    let customDialogVarVisitor = CustomDialogVarVisitor()
    let customDialogInput1: ClassDecl

    TestCustomDialogVarVisitorTraverse() {
        this.customDialogInput1 = (parseDecl(cangjieLex(customDialogStr1)) as ClassDecl).getOrThrow()
    }

    // in func checkCustomDialogController
    @Bench
    func BenchmarkVisitorTraverse_customDialogVarVisitor_001(): Unit {
        blackBox(customDialogInput1.traverse(customDialogVarVisitor))
    }
}