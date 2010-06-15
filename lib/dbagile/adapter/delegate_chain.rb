module DbAgile
  class DelegateChain
    include DbAgile::Adapter::Delegate
    
    # Creates a chain instance with a default delegate
    def initialize(delegate)
      @delegate = delegate
    end
    
    # Put a new delegate on top of the chain
    def unshift_delegate(delegate)
      delegate.delegate = @delegate
      @delegate = delegate
      self
    end
    
  end # class ChainAdapter
end # module ChainAdapter