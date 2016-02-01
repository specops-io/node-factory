shared_examples "a vagrant box" do
  describe "accounts" do
    describe "vagrant" do
      describe group "vagrant"  do
        it { should exist }
      end

      describe user "vagrant" do
        it { should exist }
        it { should belong_to_group "vagrant" }
        it { should belong_to_group "users" }
        it { should belong_to_group "vboxsf" }
        it { should have_home_directory "/home/vagrant" }
        it { should have_login_shell "/bin/bash" }

        describe "sudo" do
          describe file "/etc/sudoers.d/vagrant" do
            it { should exist }
            it { should be_mode 440 }
            it { should be_owned_by "root" }

            its(:content) { should match /Defaults env_keep \+= "SSH_AUTH_SOCK"/ }
            its(:content) { should match /vagrant ALL=\(ALL\) NOPASSWD: ALL/ }
          end
        end

        describe file "/home/vagrant/.ssh" do
          it { should exist }
          it { should be_mode 700 }
          it { should be_owned_by "vagrant" }
          it { should be_grouped_into "users" }

          describe file "/home/vagrant/.ssh/authorized_keys" do
            it { should exist }
            it { should be_mode 600 }
            it { should be_owned_by "vagrant" }
            it { should be_grouped_into "users" }
          end
        end
      end
    end
  end

  describe "services" do
    describe service "sshd" do
      it { should be_enabled }
      it { should be_running.under("systemd") }

      describe package "openssh" do
        it { should be_installed }
      end

      describe port(22) do
        it { should be_listening }
      end
    end
  end

  describe "virtualbox" do
    describe "packages" do
      %w(
        linux-headers
        virtualbox-guest-utils
        virtualbox-guest-dkms
        nfs-utils
      ).each do |package_name|
        describe package package_name do
          it { should be_installed }
        end
      end
    end

    describe "configuration" do
      describe file "/etc/modules-load.d/virtualbox.conf" do
        it { should exist }
        it { should be_owned_by "root" }

        its(:content) { should match /vboxguest/ }
        its(:content) { should match /vboxsf/ }
        its(:content) { should match /vboxvideo/ }
      end
    end

    describe "services" do
      describe service "dkms" do
        it { should be_enabled }
        it { should be_running.under("systemd") }
      end

      describe service "vboxservice" do
        it { should be_enabled }
        #it { should be_running.under("systemd") }
      end

      describe service "rpcbind" do
        it { should be_enabled }
        #it { should be_running.under("systemd") }
      end
    end
  end
end
