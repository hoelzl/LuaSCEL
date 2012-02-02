---
-- Created by IntelliJ IDEA.
-- User: tc
-- Date: Feb/2/12
-- Time: 3:17
--


-- Some simple tests for LuaSCEL

-- To get a different random seed on each run use
-- math.randomseed(os.time())

require "lua-scel"
require "lunatest"

-- module ("lua-scel-test", lunatest. package.seeall)

function test_uuid ()
    -- This is way too fragile...
    math.randomseed(1234)
    assert_equal(
        (jit and "a305d7dd-19ca-4ed9-a125-b5c164a7") or
                "056f630b-463f-46af-9372-727c2237",
        util.uuid(),
        "Generate uuid")
    -- fail("Just to try....", true)
end

function test_resolve_location ()
    assert_equal(initial_component:resolve_location("self"),
        initial_component,
        "resolve_location('self')")
    assert_nil(initial_component:resolve_location("foo"),
        "~resolve_location('foo')")
end

function test_match_tuple ()
    assert_nil(initial_component:match_tuple("foo"),
        "~match_tuple('foo')")
    initial_component.knowledge_base["foo"] = "bar"
    assert_true(initial_component:match_tuple("foo"),
        "~match_tuple('foo')")
end

function test_index_method ()
    assert_equal(initial_component.interface.get,
        initial_component.get,
        "c.interface.get ~= c.get")
end

lunatest.run()

