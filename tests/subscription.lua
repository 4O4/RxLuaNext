
local Subscription = require("reactivex.subscription")

local Observable = require("reactivex.observable")
local Observer = require("reactivex.observer")
local Subscription = require("reactivex.subscription")

describe('Subscription', function()
  describe('create', function()
    it('returns a Subscription', function()
      local subscription = Subscription.create()
      expect(subscription).to.be.an(Subscription)
    end)
  end)

  describe('unsubscribe', function()
    it('runs the teardown function if it was given upon creation', function()
      local unsubscribe = spy()
      local subscription = Subscription.create(unsubscribe)
      subscription:unsubscribe()
      expect(#unsubscribe).to.equal(1)
    end)

    it('works when teardown function was not given upon creation', function()
      local unsubscribe = spy()
      local subscription = Subscription.create(unsubscribe)
      -- subscription:unsubscribe()
      function wrapper() subscription:unsubscribe() end
      expect(wrapper).to_not.fail()
    end)

    it('ignores uncallable garbage given as a teardown upon creation and works as if it was not given at all', function()
      local subscription = Subscription.create("1234")
      function wrapper() subscription:unsubscribe() end
      expect(wrapper).to_not.fail()
    end)

    it('does not run the function passed to create more than once', function()
      local unsubscribe = spy()
      local subscription = Subscription.create(unsubscribe)
      subscription:unsubscribe()
      subscription:unsubscribe()
      subscription:unsubscribe()
      expect(#unsubscribe).to.equal(1)
    end)
  end)
end)
