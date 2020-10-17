local Observable = require("reactivex.observable")
local Observer = require("reactivex.observer")
local Subscription = require("reactivex.subscription")

require('reactivex.operators.distinctUntilChanged')

describe('distinctUntilChanged', function()
  it('produces an error if its parent errors', function()
    expect(Observable.throw():distinctUntilChanged()).to.produce.error()
  end)

  describe('with the default comparator', function()
    it('produces a value if it is the first value or different from the previous', function()
      local observable = Observable.fromTable({1, 1, 3, 1, 4, 5, 5, 5}, ipairs):distinctUntilChanged()
      expect(observable).to.produce(1, 3, 1, 4, 5)
    end)

    it('produces the first value if it is nil', function()
      local observable = Observable.of(nil):distinctUntilChanged()
      expect(observable).to.produce({{}})
    end)

    it('produces multiple onNext arguments but only uses the first argument to check for equality', function()
      local observable = Observable.fromTable({1, 1, 3, 1, 4, 5, 5, 5}, ipairs, true):distinctUntilChanged()
      expect(observable).to.produce({{1, 1}, {3, 3}, {1, 4}, {4, 5}, {5, 6}})
    end)
  end)

  describe('with a custom comparator', function()
    it('produces a value if it is the first value or the comparator returns false when passed the previous value and the current value', function()
      local observable = Observable.fromTable({1, 1, 3, 1, 4, 5, 5, 5}, ipairs):distinctUntilChanged(function(x, y) return x % 2 == y % 2 end)
      expect(observable).to.produce(1, 4, 5)
    end)

    it('produces the first value if it is nil', function()
      local observable = Observable.of(nil):distinctUntilChanged(function(x, y) return true end)
      expect(observable).to.produce({{}})
    end)

    it('calls onError if the comparator errors', function()
      expect(Observable.fromRange(2):distinctUntilChanged(error)).to.produce.error()
    end)
  end)
end)
