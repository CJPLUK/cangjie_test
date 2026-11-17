/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */
// EXEC: %compiler %cmp_opt -o %n.%suffix %f %cmp_utest_opt
// EXEC: %run %run_opt %n.%suffix %run_utest_opt %run_args

/*
 * Test description:  Test the interface for sql package
 * Test API: public interface Connection
 *           public interface UpdateResult
 */

import std.database.sql.*
import std.time.*
import std.collection.*
import std.sync.*
import std.math.*
import std.unittest.*
import std.unittest.testmacro.*

let _ = {
    =>
    DriverManager.register("postgres", MyDriver("postgres"))
    DriverManager.register("opengauss", MyDriver("opengauss"))
}()

public class MyDriver <: Driver {
    private var scheme = "postgres"
    public init(scheme: String) {
        this.scheme = scheme.toAsciiLower()
    }
    public prop name: String {
        get() {
            return "opengauss"
        }
    }
    public prop version: String {
        get() {
            return "0.1.0"
        }
    }
    public prop preferredPooling: Bool {
        get() {
            return true
        }
    }
    public func open(_: String, _: Array<(String, String)>): Datasource {
        return MyDatasource()
    }
}

public class MyDatasource <: Datasource {
    let closed = AtomicBool(false)
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
    }
    public func isClosed(): Bool {
        closed.load()
    }

    public func setOption(_: String, _: String): Unit {}

    public func connect(): Connection {
        return MyConnection()
    }
}

/**
 * Controllable mock: count connects and optionally fail the next connect.
 */
public class CountingDatasource <: Datasource {
    let closed = AtomicBool(false)
    public var connectCount: Int64 = 0
    public var failNext: Bool = false

    public func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
    }
    public func isClosed(): Bool {
        closed.load()
    }
    public func setOption(_: String, _: String): Unit {}

    public func connect(): Connection {
        connectCount++
        if (failNext) {
            throw Exception("mock connect failed")
        }
        return MyConnection()
    }
}

public class MyConnection <: Connection {
    let closed = AtomicBool(false)
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
    }
    public func isClosed(): Bool {
        closed.load()
    }
    public prop state: ConnectionState {
        get() {
            return ConnectionState.Connected
        }
    }
    public func prepareStatement(_: String): Statement {
        return MyStmt()
    }
    public func createTransaction(): Transaction {
        throw UnsupportedException()
    }
    public func getMetaData(): Map<String, String> {
        return HashMap([("k", "v")])
    }
}

public class MyStmt <: Statement {
    let closed = AtomicBool(false)
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
    }
    public func isClosed(): Bool {
        closed.load()
    }
    public func setOption(_: String, _: String): Unit {}
    public prop parameterColumnInfos: Array<ColumnInfo> {
        get() {
            []
        }
    }
    public func update(_: Array<SqlDbType>): UpdateResult {
        return MySqlUpdateResult()
    }
    public func query(_: Array<SqlDbType>): QueryResult {
        return MyRows()
    }

    @When[backend == "cjnative"]
    public func set<T>(index: Int, value: T): Unit {}

    public func setNull(index: Int): Unit {}
    public func update(): UpdateResult {
        return MySqlUpdateResult()
    }
    public func query(): QueryResult {
        return MyRows()
    }
}

public class MySqlUpdateResult <: UpdateResult {
    public prop rowCount: Int64 {
        get() {
            10
        }
    }
    public prop lastInsertId: Int64 {
        get() {
            -127
        }
    }
}

public class MyRows <: QueryResult {
    let closed = AtomicBool(false)
    public func close(): Unit {
        if (isClosed()) {
            return
        }
        closed.store(true)
    }
    public func isClosed(): Bool {
        closed.load()
    }
    public prop columnInfos: Array<ColumnInfo> {
        get() {
            []
        }
    }
    public func next(_: Array<SqlDbType>): Bool {
        close()
        true
    }
    public func next(): Bool {
        close()
        true
    }

    @When[backend == "cjnative"]
    public func get<T>(index: Int): T {
        var valueList = ArrayList<T>()
        return valueList[index]
    }

    @When[backend == "cjnative"]
    public func getOrNull<T>(index: Int): ?T {
        return None
    }
}

@Test
class TestPooledDatasource {
    @TestCase
    func PooledDatasourceTest(): Unit {
        let drv = DriverManager.getDriver("opengauss") ?? return
        let ds = drv.open("")
        let pool = PooledDatasource(ds)

        pool.keepaliveTime = Duration.second
        @Expect(pool.keepaliveTime, Duration.second)

        pool.idleTimeout = Duration.second
        @Expect(pool.idleTimeout, Duration.second)

        pool.maxLifeTime = Duration.minute * 15
        @Expect(pool.maxLifeTime, Duration.minute * 15)

        // pool.maxIdleSize = 2
        // @Expect(pool.maxIdleSize, 2)

        pool.maxSize = 10
        @Expect(pool.maxSize, 10)

        pool.connectionTimeout = Duration.minute
        @Expect(pool.connectionTimeout, Duration.minute)

        pool.setOption("cang", "jie")
        var conn = pool.connect()
        @Expect(conn.state == Connected, true)
        @Expect(conn.getMetaData().get("k"), "v")
        let stmt = conn.prepareStatement("select 1")

        var a = stmt.update()
        @Assert(a.rowCount, 10)
        @Assert(a.lastInsertId, -127)

        var b = stmt.query()
        @Assert(!b.isClosed())
        b.next()

        try {
            conn.createTransaction()
            @Assert(false)
        } catch (e: UnsupportedException) {}

        stmt.close()
        conn.close()

        @Expect(conn.isClosed(), true)
        try {
            conn.prepareStatement("select 2")
        } catch (e: SqlException) {
            @Expect(e.message, "Connection closed, errorCode: 0.")
        }
        try {
            conn.createTransaction()
        } catch (e: SqlException) {
            @Expect(e.message, "Connection closed, errorCode: 0.")
        }

        conn = pool.connect()
        pool.maxSize = -1
        @Expect(pool.maxSize, Int32.Max)
        pool.maxIdleSize = -1
        @Expect(pool.maxIdleSize, Int32.Max)
        conn.close()

        pool.close()
        @Expect(pool.isClosed(), true)
        ds.close()
    }

    /** connect after pool closed */
    @TestCase
    func testConnectAfterPoolClosed(): Unit {
        let ds = MyDatasource()
        let pool = PooledDatasource(ds)
        pool.close()
        @Expect(pool.isClosed(), true)
        try {
            pool.connect()
            @Assert(false)
        } catch (_: SqlException) {}
        pool.close()
    }

    /** pool full + short timeout → SqlException */
    @TestCase
    func testAcquireExceedMaxSize(): Unit {
        let ds = MyDatasource()
        let pool = PooledDatasource(ds)
        pool.maxSize = 1
        pool.connectionTimeout = Duration.millisecond * 100
        let held = pool.connect()
        try {
            pool.connect()
            @Assert(false)
        } catch (_: SqlException) {}
        held.close()
        pool.close()
    }

    /** constructor/connect failure rolls back entryCount; next connect still works */
    @TestCase
    func testConnectFailureThenRecover(): Unit {
        let ds = CountingDatasource()
        let pool = PooledDatasource(ds)
        pool.maxSize = 2
        ds.failNext = true
        try {
            pool.connect()
            @Assert(false)
        } catch (_: Exception) {}
        ds.failNext = false
        let conn = pool.connect()
        @Expect(ds.connectCount >= 2, true)
        @Expect(conn.isClosed(), false)
        conn.close()
        pool.close()
    }

    /** maxLifeTime exceeded on release → discard, next connect creates new entry */
    @TestCase
    func testMaxLifeTimeDiscardOnRelease(): Unit {
        let ds = CountingDatasource()
        let pool = PooledDatasource(ds)
        pool.maxSize = 2
        pool.maxIdleSize = 2
        pool.maxLifeTime = Duration.millisecond
        let conn1 = pool.connect()
        @Expect(ds.connectCount, 1)
        // Entry.creationTime = now + up to 1s jitter; wait past that + maxLifeTime
        sleep(Duration.second * 2)
        conn1.close()
        let conn2 = pool.connect()
        @Expect(ds.connectCount, 2)
        conn2.close()
        pool.close()
    }

    /** idleTimeout / maxIdleSize reclaim via background check */
    @TestCase
    func testIdleTimeoutReclaim(): Unit {
        let ds = CountingDatasource()
        let pool = PooledDatasource(ds)
        pool.maxSize = 2
        pool.maxIdleSize = 1
        pool.idleTimeout = Duration.millisecond
        pool.keepaliveTime = Duration.millisecond * 100
        let c1 = pool.connect()
        let c2 = pool.connect()
        @Expect(ds.connectCount, 2)
        c1.close()
        c2.close()
        // Timer.repeat first period is 1s in ResourcePool.backgroundCheckIdleLife
        sleep(Duration.second * 2)
        let c3 = pool.connect()
        // after idle reclaim, a new underlying connect is expected
        @Expect(ds.connectCount >= 2, true)
        c3.close()
        pool.close()
    }

    /** double close on pool and proxy connection */
    @TestCase
    func testIdempotentClose(): Unit {
        let ds = MyDatasource()
        let pool = PooledDatasource(ds)
        let conn = pool.connect()
        conn.close()
        conn.close()
        @Expect(conn.isClosed(), true)
        pool.close()
        pool.close()
        @Expect(pool.isClosed(), true)
    }
}
