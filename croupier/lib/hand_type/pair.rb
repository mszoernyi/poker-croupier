
module HandType
  class Pair < Base

    def handles?
      nOfAKind? 2
    end

    def rank
      1
    end

    def value
      highestSameValue 2
    end

  end
end