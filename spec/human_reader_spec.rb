require "spec_helper"

describe HumanReader do
  it do
    assert { HumanReader.new("霊魂切断").to_s     == "れいこんせつだん" }
    assert { HumanReader.new("ヴータン").to_s     == "ぶーたん"         }
    assert { HumanReader.new("ヴォイス").to_s     == "ぼいす"           }
    assert { HumanReader.new("ヴィンテージ").to_s == "びんてーじ"       }
  end
end
