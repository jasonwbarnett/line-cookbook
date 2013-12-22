#
# Cookbook Name:: line
# Library:: provider_delete_lines
#
# Author:: Sean OMeara <someara@opscode.com>
# Author:: Jeff Blaine <jblaine@kickflop.net>
# Copyright 2012-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'fileutils'
require 'tempfile'

class Chef
  class Provider
    #
    class DeleteLines < Chef::Provider
      def load_current_resource
      end

      def stat_file(fd)
        @file_owner = fd.lstat.uid
        @file_group = fd.lstat.gid
        @file_mode = fd.lstat.mode
      end

      def replace_file(source, target)
        stat_file
        source.rewind
        FileUtils.copy_file(sourcee.path, target.path)
        FileUtils.chown(@file_owner, @file_group, target.path)
        FileUtils.chmod(@file_mode, targer.path)
        source.close
      end

      def grep_dash_v(path, tempfile, regex)
        f = ::File.open(path, 'r+')
        @modified = false
        f.lines.each do |line|
          if line =~ regex
            @modified = true
          else
            tempfile.puts line
          end
        end
        f.close
      end

      def action_edit
        if ::File.exists?(new_resource.path)
          temp_file = Tempfile.new('foo')
          grep_dash_v new_resource.path, temp_file, /#{new_resource.pattern}/

          if @modified
            replace_file temp_file, new_resource
            new_resource.updated_by_last_action(true)
          end

          temp_file.unlink
        end
      end

      def action_nothing
      end
    end
  end
end
