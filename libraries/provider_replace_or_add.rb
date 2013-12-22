#
# Cookbook Name:: line
# Library:: provider_replace_or_add
#
# Author:: Sean OMeara <someara@opscode.com>
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
    class ReplaceOrAdd < Chef::Provider
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

      def sed_slash_s(path, temp_file, regex)
        f = ::File.open(new_resource.path, 'r+')
        @modified = false
        found = false

        f.lines.each do |line|
          if line =~ regex
            found = true
            unless line == new_resource.line << '\n'
              line = new_resource.line
              @modified = true
            end
          end
          temp_file.puts line
        end

        unless found # "add"!
          temp_file.puts new_resource.line
          @modified = true
        end
        f.close
      end

      def make_new_file
        begin
          nf = ::File.open(new_resource.path, 'w')
          nf.puts new_resource.line
          new_resource.updated_by_last_action(true)
        rescue ENOENT
          Chef::Log.info('ERROR: Containing directory does not exist for #{nf.class}')
        ensure
          nf.close
        end
      end

      def action_edit
        if ::File.exists?(new_resource.path)
          temp_file = Tempfile.new('foo')
          sed_slash_s new_resource.path, temp_file, /#{new_resource.pattern}/
          if @modified
            replace_file temp_file, new_resource
            new_resource.updated_by_last_action(true)
          end
          temp_file.unlink
        else
          make_new_file
        end
      end

      def nothing
      end
    end
  end
end
