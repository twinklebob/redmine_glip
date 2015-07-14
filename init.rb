Redmine::Plugin.register :redmine_glip do
  name 'Glip'
  author 'David Lumm'
  description 'Sends notifications to Glip.'
  version '0.0.1'
  url 'https://github.com/twinklebob/redmine_kato'
  author_url 'https://github.com/twinklebob/'

  Rails.configuration.to_prepare do
    require_dependency 'glip_hooks'
    require_dependency 'glip_view_hooks'
    require_dependency 'project_patch'
    Project.send(:include, RedmineGlip::Patches::ProjectPatch)
  end

  settings :partial => 'settings/redmine_glip',
    :default => {
      :glip_url => ""
    }
end
