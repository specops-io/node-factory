require_relative "../../spec/shared_examples"

describe "specops-io/archlinux-ansible" do
  it_behaves_like "archlinux"
  it_behaves_like "a vagrant box"
  it_behaves_like "an ansible capable node"
end
