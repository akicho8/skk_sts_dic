require "spec_helper"

describe Normalizer do
  it do
    assert { Normalizer.new(["霊魂　切断"]).to_a == ["霊魂 切断"] }
  end
end
