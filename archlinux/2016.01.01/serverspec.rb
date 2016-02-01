require_relative "../../spec/shared_examples"

describe "specops-io/archlinux-2016.01.01" do
  it_behaves_like "archlinux"
  it_behaves_like "a vagrant box"
end
