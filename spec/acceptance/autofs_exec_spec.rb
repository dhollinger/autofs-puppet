require 'spec_helper_acceptance'

describe 'autofs::mount exec tests' do
  context 'basic exec test' do
    it 'applies' do
      pp = <<-EOS
        class { 'autofs': }
        autofs::mount { 'exec':
          mount       => '/exec',
          mapfile     => '/etc/auto.exec',
          mapcontents => [ 'test_exec -o rw /mnt/test_exec' ],
          options     => '--timeout=120',
          order       => 01,
          execute     => true
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/auto.master') do
      it 'should exist and have content' do
        is_expected.to exist
        is_expected.to be_owned_by 'root'
        is_expected.to be_grouped_into 'root'
        shell('cat /etc/auto.master') do |s|
          expect(s.stdout).to match(/\/exec \/etc\/auto.exec --timeout=120/)
        end
      end
    end

    describe file('/etc/auto.exec') do
      it 'should exist and have content' do
        is_expected.to exist
        is_expected.to be_owned_by 'root'
        is_expected.to be_grouped_into 'root'
        shell('cat /etc/auto.exec') do |r|
          expect(r.stdout).to match(/test_exec -o rw \/mnt\/test_exec/)
        end
      end
    end

    describe package('autofs') do
      it { is_expected.to be_installed }
    end

    describe service('autofs') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

  end
end
