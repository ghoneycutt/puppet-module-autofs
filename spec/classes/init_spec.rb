require 'spec_helper'

describe 'autofs' do
  platforms = {
    'RedHat' =>
      {
        :osfamily     => 'RedHat',
        :package_name => 'autofs',
        :service_name => 'autofs',
        :config_file  => '/etc/sysconfig/autofs',
      },
    'Suse' =>
      {
        :osfamily     => 'Suse',
        :package_name => 'autofs',
        :service_name => 'autofs',
        :config_file  => '/etc/sysconfig/autofs',
      },
    'Debian' =>
      {
        :osfamily     => 'Debian',
        :package_name => 'autofs',
        :service_name => 'autofs',
        :config_file  => '/etc/default/autofs',
      },
  }

  describe 'with default values for parameters' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do
        let :facts do
          {
            :osfamily   => v[:osfamily],
          }
        end

        it {
          should contain_package("#{v[:package_name]}").with({
            'ensure' => 'present',
            'name'   => v[:package_name],
          })
        }

        it {
          should contain_service("#{v[:service_name]}").with({
            'ensure'    => true,
            'enable'    => true,
            'name'      => v[:service_name],
          })
        }

        it {
          should contain_file('/etc/auto.master').with({
            'ensure'  => 'file',
            'path'    => '/etc/auto.master',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => "Package[#{v[:package_name]}]",
            'notify'  => "Service[#{v[:service_name]}]",
          })
        }

        it { should contain_file("#{v[:config_file]}").with_content(/BROWSE_MODE=no$/) }
        it { should contain_file("#{v[:config_file]}").with_content(/TIMEOUT=300$/) }

      end
    end
  end

  describe 'with optional parameters set' do
    platforms.sort.each do |k,v|
      context "where osfamily is <#{v[:osfamily]}>" do
        let :facts do
          {
            :osfamily          => v[:osfamily],
          }
        end

        context 'where enable is false' do
          let :params do
            {
              :enable => false,
            }
          end

          it {
            should contain_service('autofs').with({
              'ensure'  => false,
              'enable'  => false,
            })

          }
        end

        context 'where timeout is changed to 84600' do
          let :params do
            {
              :mount_timeout  => '84600',
            }
          end
          it { should contain_file("#{v[:config_file]}").with_content(/TIMEOUT=84600$/) }
        end

        context 'where umount_wait is set to 2' do
          let :params do
            {
              :umount_wait  => '2',
            }
          end
          it { should contain_file("#{v[:config_file]}").with_content(/UMOUNT_WAIT=2$/) }
        end

        context 'where mounts is set' do
          let :params do
            {
              :mounts  => [ '+auto.master', '/somepath auto.somepath'],
            }
          end
          it { should contain_file('/etc/auto.master').with_content(/^\+auto.master$/) }
          it { should contain_file('/etc/auto.master').with_content(/^\/somepath auto.somepath$/) }
        end

      end
    end
  end
end

