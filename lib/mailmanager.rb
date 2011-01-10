require "singleton"
require "rubygems"
require "bundler/setup"

require 'mailmanager/lib'
require 'mailmanager/list'

module MailManager
  @root = nil

  def self.root=(root)
    @root = root
  end

  def self.root
    @root
  end

  class Base
    include Singleton

    REQUIRED_BIN_FILES = ['add_members', 'remove_members', 'list_lists',
                          'list_members', 'newlist', 'rmlist', 'sync_members']

    def initialize
      raise "Must set MailManager.root before calling #{self.class}.instance" if MailManager.root.nil?
      raise "#{root} does not exist" unless Dir.exist?(root)
      raise "#{root}/bin does not exist" unless Dir.exist?("#{root}/bin")
      REQUIRED_BIN_FILES.each do |bin_file|
        raise "#{root}/bin/#{bin_file} not found" unless File.exist?("#{root}/bin/#{bin_file}")
      end
      @lib = MailManager::Lib.new
    end

    def root
      MailManager.root
    end

    def lists
      @lib.lists
    end
  end

end
