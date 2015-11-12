require 'spec_helper'

describe Capistrano::Release::Tag do
  it 'has a version number' do
    expect(Capistrano::Release::Tag::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
