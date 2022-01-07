require 'spec_helper'
require_relative '../../../lib/puppet/functions/cd4pe_deployments/get_node_group'
require 'webmock/rspec'

describe 'cd4pe_deployments::get_node_group' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  it 'requires 1 parameters' do
    is_expected.to run.with_params.and_raise_error(ArgumentError)
  end

  context 'happy' do
    include_context 'deployment'

    it 'succeeds with parameters' do
      stub_request(:get, ajax_url)
        .with(query: { op: 'GetNodeGroupInfo', deploymentId: deployment_id, nodeGroupId: node_group_id }, headers: { 'authorization' => ENV['DEPLOYMENT_TOKEN'] })
        .to_return(body: JSON.generate(response['result']))
        .times(1)

      is_expected.to run.with_params(node_group_id).and_return(response)
    end

    it 'fails with non-200 response code' do
      stub_request(:get, ajax_url)
        .with(query: { op: 'GetNodeGroupInfo', deploymentId: deployment_id, nodeGroupId: node_group_id }, headers: { 'authorization' => ENV['DEPLOYMENT_TOKEN'] })
        .to_return(body: JSON.generate(error_response), status: 404)
        .times(1)

      is_expected.to run.with_params(node_group_id).and_return(error_response)
    end
  end
end
