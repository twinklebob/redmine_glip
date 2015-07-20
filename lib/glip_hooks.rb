# encoding: utf-8

require 'Glip'

class NotificationHook < Redmine::Hook::Listener

  def controller_issues_new_after_save(context={ })
    project = context[:project]
    return true if !glip_configured?(project)

    issue = context[:issue]
    user = issue.author
    assigned = issue.assigned_to_id.blank? ? "anyone yet" : "#{issue.assigned_to.name}"
    project = issue.project
    tracker = issue.tracker.name.downcase
    message = "#{user.name} created issue ##{issue.id} (#{tracker}) [#{issue.subject}](#{Setting[:protocol]}://#{Setting.host_name}/issues/#{issue.id}) at [#{project.name}](#{Setting[:protocol]}://#{Setting.host_name}/projects/#{project.name}).\n\nAssigned to: #{assigned}"
    send_message(glip_url(project), "New Issue ##{issue.id}" , message)
  end

  def controller_issues_edit_after_save(context = { })
    issue = context[:issue]
    project = issue.project
    return true if !glip_configured?(project)

    params = context[:params]
    journal = context[:journal]
    notes = journal.notes
    tracker = issue.tracker.name.downcase
    message = "#{journal.user} edited issue ##{issue.id} (#{tracker}) [#{issue.subject}](#{Setting[:protocol]}://#{Setting.host_name}/issues/#{issue.id}) at [#{project.name}](#{Setting[:protocol]}://#{Setting.host_name}/projects/#{project.name})\n\n#{truncate_words(notes)}"
    send_message(glip_url(project), "Issue ##{issue.id} updated", message)
  end

  def controller_wiki_edit_after_save(context = {})
    page = context[:page]
    project = page.wiki.project
    return true if !glip_configured?(project)

    wiki = page.pretty_title
    author = User.current.name
    url = "#{Setting[:protocol]}://#{Setting[:host_name]}/projects/#{page.wiki.project.identifier}/wiki/#{page.title}"
    message = "#{author} edited [#{project.name}](#{Setting[:protocol]}://#{Setting.host_name}/projects/#{project.name}) wiki page [#{wiki}](#{url})"
    send_message(glip_url(project), "#{project.name} wiki page #{wiki} updated", message)
  end

  def glip_url(project)
    return project.glip_url if !project.glip_url.empty?
    return Setting.plugin_redmine_glip[:glip_url]
  end

  def glip_configured?(project)
    if !project.glip_url.empty?
      return true
    elsif Setting.plugin_redmine_glip[:glip_url] &&
          Setting.plugin_redmine_glip[:projects] &&
          Setting.plugin_redmine_glip[:projects].include?(project.id.to_s)
      return true
    else
      Rails.logger.info "Not sending Glip message - missing config"
    end
    false
  end

  def send_message(glip_url, title, message)
    begin
      room = Glip::Room.new({:full_url => glip_url})
      room.post({:title => title, :body => message})
    rescue => e
      Rails.logger.error "Error when trying to send message to glip: #{e.message}"
    end
  end

  def truncate_words(text, length = 25, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
