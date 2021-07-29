# frozen_string_literal: true

require_relative "spec_helper"

class Sample
  def initialize(attributes)
    attributes.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end
end

class SampleWithHash
  def initialize(attributes)
    @attributes = attributes
  end

  def to_hash
    @attributes
  end
end

describe Object do
  it "serializes a simple PORO" do
    object = Sample.new(name: "foo", value: "bar")
    expect(object.as_json).to eq({"name" => "foo", "value" => "bar"})
  end

  it "serializes an object that implements to_hash" do
    hash = {foo: "bar"}
    object = SampleWithHash.new(hash)
    expect(object.as_json).to eq hash.as_json
  end

  it "serializes nested objects" do
    children = []
    object = Sample.new(name: "parent", children: children)
    child_1 = Sample.new(name: "child_1")
    child_2 = Sample.new(name: "child_2")
    children.concat([child_1, child_2])
    expect(object.as_json).to eq({"name" => "parent", "children" => [{"name" => "child_1"}, {"name" => "child_2"}]})
  end

  it "serializes nested objects with backreferences" do
    children = []
    object = Sample.new(name: "parent", children: children)
    child_1 = Sample.new(name: "child_1", parent: object)
    child_2 = Sample.new(name: "child_2", parent: child_1)
    child_3 = Sample.new(name: "child_3")
    child_4 = Sample.new(name: "child_4", parent: {owner: child_3})
    children.concat([child_1, child_2, child_4])
    expected_hash = {
      "name" => "parent",
      "children" => [
        {"name" => "child_1"},
        {"name" => "child_2", "parent" => {"name" => "child_1"}},
        {"name" => "child_4", "parent" => {"owner" => {"name" => "child_3"}}}
      ]
    }
    expect(object.as_json).to eq expected_hash
  end

  it "supports filtering with :only option" do
    stub_const("SafeObjectAsJson::SUPPORT_FILTERING", true)
    object = Sample.new(name: "foo", value: "bar")
    expect(object.as_json(only: :name)).to eq({"name" => "foo"})
  end

  it "supports filtering with :except option" do
    stub_const("SafeObjectAsJson::SUPPORT_FILTERING", true)
    object = Sample.new(name: "foo", value: "bar")
    expect(object.as_json(except: :name)).to eq({"value" => "bar"})
  end
end
