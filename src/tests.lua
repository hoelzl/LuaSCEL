-- Some simple tests for LuaSCEL

require "scelua"
require "lunatest"

require "remdebug.engine"

print("Starting remote debugger.\n")
util.sleep(1)
remdebug.engine.start()

local lunatest = _G.lunatest
local assert_equal  = _G.assert_equal
local assert_true, assert_nil = _G.assert_true, _G.assert_nil
local jit = _G.jit
local util = _G.util
local initial_component = _G.initial_component


function test_uuid ()
    -- This is way too fragile...
    -- To get a different random seed on each run, change 1234 to
    -- os.time()
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

print(package.path)
lunatest.run()

