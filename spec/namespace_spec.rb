# encoding: utf-8
require 'spec_helper'
require 'piret'

describe Piret::Namespace do
  describe "the [] method" do
    it "should vivify non-extant namespaces" do
      Piret::Namespace.exists?(:vivify_test).should eq false
      Piret::Namespace[:vivify_test].should be_an_instance_of Piret::Namespace
      Piret::Namespace.exists?(:vivify_test).should eq true
    end
  end

  describe "the Piret[] shortcut" do
    it "should directly call the [] method" do
      Piret::Namespace.should_receive(:[]).with(:trazzle)
      Piret[:trazzle]
    end
  end

  describe "the refer method" do
    it "should cause items in one namespace to be locatable from the other" do
      abc = Piret::Namespace.new :abc
      xyz = Piret::Namespace.new :xyz

      xyz.refer abc

      abc.set_here :hello, :wow
      xyz[:hello].should eq :wow
    end

    it "may not be used to refer namespaces to themselves" do
      lambda {
        Piret[:user].refer Piret[:user]
      }.should raise_exception(Piret::Namespace::RecursiveNamespaceError)
    end
  end

  describe "the piret.builtin namespace" do
    before do
      @ns = Piret[:"piret.builtin"]
    end

    it "should contain elements from Piret::Builtins" do
      @ns[:let].should be_an_instance_of Piret::Builtin
      @ns[:quote].should be_an_instance_of Piret::Builtin
    end

    it "should contain fundamental objects" do
      @ns[:nil].should eq nil
      @ns[:true].should eq true
      @ns[:false].should eq false
    end

    it "should not find objects from ruby" do
      lambda {
        @ns[:Float]
      }.should raise_exception(Piret::Eval::BindingNotFoundError)
      lambda {
        @ns[:String]
      }.should raise_exception(Piret::Eval::BindingNotFoundError)
    end

    it "should have a name" do
      @ns.name.should eq :"piret.builtin"
    end
  end

  describe "the ruby namespace" do
    before do
      @ns = Piret::Namespace[:ruby]
    end

    it "should contain elements from Kernel" do
      @ns[:Hash].should eq Hash
      @ns[:Fixnum].should eq Fixnum
    end

    it "should have a name" do
      @ns.name.should eq :ruby
    end
  end
end

# vim: set sw=2 et cc=80:
