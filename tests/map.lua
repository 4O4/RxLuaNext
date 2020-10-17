local Observable = require("reactivex.observable")
local Observer = require("reactivex.observer")
local Subscription = require("reactivex.subscription")

require('reactivex.operators.map')

describe('map', function()
  it('produces an error if its parent errors', function()
    local observable = Observable.throw():map(function(x) return x end)
    expect(observable).to.produce.error()
    expect(observable:map()).to.produce.error()
  end)

  it('uses the identity function as the callback if none is specified', function()
    local observable = Observable.fromRange(5):map()
    expect(observable).to.produce(1, 2, 3, 4, 5)
  end)

  it('passes all arguments to the predicate and produces all of its return values', function()
    local callback = spy(function() return 1, 2, 3 end)
    local observable = Observable.fromTable({3, 2, 1}, ipairs, true):map(callback)
    expect(observable).to.produce({{1, 2, 3}, {1, 2, 3}, {1, 2, 3}})
    expect(callback).to.equal({{3, 1}, {2, 2}, {1, 3}})
  end)

  it('calls onError if the callback errors', function()
    expect(Observable.fromRange(3):map(error)).to.produce.error()
  end)
end)
