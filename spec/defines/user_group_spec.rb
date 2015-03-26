require 'spec_helper'

describe '::user_group', :type => :define do
  on_supported_os.each do |os, facts|
    context "on #{os} with puppet v#{Puppet.version}" do
      let(:facts) do facts end
      let :default_resource_title do 'rspec_user' end
      let :default_params do {} end
      let :title do default_resource_title end
      describe "::user_group define with no parameters" do
        let :params do default_params end

        it { should compile.with_all_deps }
        it { should contain_class('user_group::params') }
        it { should contain_user_group(default_resource_title) }
        it { should contain_user(default_resource_title) }
        it { should contain_group(default_resource_title) }
      end
    end
  end
end
