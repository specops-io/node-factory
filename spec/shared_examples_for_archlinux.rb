shared_examples "archlinux" do
  describe "packages" do
    %w(
      archlinux-keyring
      base
      base-devel
      curl
      net-tools
      openssh
      package-query
      syslinux
      sudo
      yaourt
    ).each do |package_name|
      describe package package_name do
        it { should be_installed }
      end
    end
  end

  describe "accounts" do
    describe "sudo" do
      describe file "/etc/sudoers" do
        let(:expected_content) do
          "root ALL=(ALL) ALL\n\n" +
            "## Read drop-in files from /etc/sudoers.d\n" +
            "## (the '#' here does not indicate a comment)\n" +
            "#includedir /etc/sudoers.d\n"
        end

        it { should exist }
        it { should be_mode 440 }
        it { should be_owned_by "root" }

        its(:content) { should match expected_content }
      end
    end

    describe "arch" do
      describe group "arch"  do
        it { should exist }
      end

      describe user "arch" do
        it { should exist }
        it { should belong_to_group "arch" }
        it { should belong_to_group "users" }
        it { should have_home_directory "/home/arch" }
        it { should have_login_shell "/bin/bash" }

        describe "sudo" do
          describe file "/etc/sudoers.d/arch" do
            it { should exist }
            it { should be_mode 440 }
            it { should be_owned_by "root" }

            its(:content) { should match /Defaults env_keep \+= "SSH_AUTH_SOCK"/ }
            its(:content) { should match /arch ALL=\(ALL\) NOPASSWD: ALL/ }
          end
        end
      end
    end
  end

  # http://comments.gmane.org/gmane.linux.arch.general/48739
  describe "workaround for shutdown race condition" do
    describe file "/etc/systemd/system/poweroff.timer" do
      let(:expected_content) do
        "[Unit]\nDescription=Delayed poweroff\n\n[Timer]\nOnActiveSec=1\nUnit=poweroff.target\n"
      end

      it { should exist }
      it { should be_owned_by 'root' }

      its(:content) { should match expected_content }
    end
  end
end
