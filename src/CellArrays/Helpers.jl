
@generated function cellsumsize(asize::NTuple{N,Int},::Val{D}) where {N,D}
  @assert N > 0
  @assert D <= N
  str = join([ "asize[$i]," for i in 1:N if i !=D ])
  Meta.parse("($str)")
end

@generated function cellsumvals!(A::Array{T,N},B,::Val{D}) where {T,N,D}
  @assert N > 0
  @assert D <= N
  quote
    B .= zero(T)
    @nloops $N a A begin
      @nexprs $(N-1) j->(b_j = a_{ j < $D ? j : j+1  } )
      (@nref $(N-1) B b) += @nref $N A a 
    end
  end    
end
