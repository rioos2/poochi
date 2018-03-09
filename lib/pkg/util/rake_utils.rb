require 'rake'

# Utility methods for working with rake tasks. These utilities will not work
# if the packaging repo was loaded as a library unless rake has been required
# explicitly.

module Pkg::Util::RakeUtils
  class << self
    def using_rake?
      defined?(Rake::Task)
    end

    def task_defined?(task_name)
      Rake::Task.task_defined?(task_name) if using_rake?
    end

    #  Return the Rake::Task object associated with a task name
    #
    def get_task(task_name)
      Rake::Task[task_name] if using_rake? && task_defined?(task_name)
    end

    def invoke_task(task, *args)
      Rake::Task[task].reenable
      Rake::Task[task].invoke(*args)
    end

    #  Add a dependency to a rake task. "depender" must be an instance of
    #  Rake::Task, but dependency can be either a Rake::Task instance, or a String
    #  referring to the name of a Rake::Task instance.
    #
    def add_dependency(depender, dependency)
      if using_rake?
        if !task_defined?(depender)
          raise "Could not locate a Rake task named '#{depender}' to add a dependency of '#{dependency}' to"
        elsif !task_defined?(dependency)
          raise "Could not locate a Rake task named '#{dependency}' to add as a dependency of '#{depender}'"
        else
          depender_task = Rake::Task[depender]
          depender_task.enhance([dependency])
        end
      end
    end

    #  Evaluate any pre-tasks known by the configuration of this invocation.
    #  Again, this is quite pointless if the user has not invoked the packaging
    #  repo via rake, so we're just not going to do anything.
    #
    def evaluate_pre_tasks
      if using_rake? && Pkg::Config.pre_tasks
        unless Pkg::Config.pre_tasks.is_a?(Hash)
          raise "The 'pre_tasks' key must be a Hash of depender => dependency pairs"
        end
        Pkg::Config.pre_tasks.each do |depender, dependency|
          add_dependency(depender, dependency)
        end
      end
    end

    def load_packaging_tasks(packaging_root = Pkg::Config.packaging_root)
      packaging_task_dir = File.join(packaging_root, 'tasks')

      tasks = [
        'clean.rake',
        'deb.rake',
        'ee_deb.rake',
        'ee_rpm.rake',
        'rpm.rake'
      ]

      tasks.each do |task|
        load File.join(packaging_task_dir, task)
      end

      # Pkg::Util::RakeUtils.evaluate_pre_tasks
    end
  end
end
