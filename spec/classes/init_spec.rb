require 'spec_helper'

describe 'autofs' do
  describe 'verify_autofs' do
    let(:facts) { {:osfamily => 'redhat',
                   :lsbmajdistrelease => '6' } }
    let(:title) { 'auto_master' }
    it { 
      should include_class('autofs')
      should contain_package('autofs').with({
        'ensure' => 'present',
      })
    }
    it { 
      should include_class('autofs')
      should contain_file('auto.master').with({
        'ensure'  => 'file',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'path'    => '/etc/auto.master',
       })
     }
    it {
      should include_class('autofs')
      should contain_service('autofs').with({
        'ensure'     => 'running',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'true',
      })
    }
  end
end
