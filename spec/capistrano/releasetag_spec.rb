require 'spec_helper'

describe Capistrano::Releasetag do
  it 'has a version number' do
    expect(Capistrano::Releasetag::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
