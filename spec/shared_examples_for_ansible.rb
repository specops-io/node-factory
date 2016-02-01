shared_examples "an ansible capable node" do
  describe "packages" do
    %w(
      python2
      python2-pip
    ).each do |package_name|
      describe package package_name do
        it { should be_installed }
      end
    end

    describe file "/usr/bin/ansible" do
      it { should exist }
    end
  end
end
