module RedmineGlip
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          safe_attributes 'glip_url'
        end
      end
    end
  end
end
