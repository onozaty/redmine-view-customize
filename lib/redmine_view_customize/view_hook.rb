require 'time'

module RedmineViewCustomize
  class ViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context={})
      path = Redmine::CodesetUtil.replace_invalid_utf8(context[:request].path_info);

      html = "\n<!-- [view customize plugin] path:#{path} -->\n"
      html << stylesheet_link_tag("view_customize", plugin: "view_customize")
      html << "<script type=\"text/javascript\">\n//<![CDATA[\n"
      html << "ViewCustomize = { context: #{create_view_customize_context(context).to_json} };"
      html << "\n//]]>\n</script>\n"

      html << create_view_customize_html(context, ViewCustomize::INSERTION_POSITION_HTML_HEAD)

      return html
    end

    def view_layouts_base_body_bottom(context={})
      return "\n" + create_view_customize_html(context, ViewCustomize::INSERTION_POSITION_HTML_BOTTOM)
    end

    def view_issues_form_details_bottom(context={})

      return "\n" + create_view_customize_html(context, ViewCustomize::INSERTION_POSITION_ISSUE_FORM)
    end

    def view_issues_show_details_bottom(context={})

      issue = {
        "id" => context[:issue].id,
        "author" => {
          "id" => context[:issue].author.id,
          "name" => context[:issue].author.name
        }
      }

      if context[:issue].last_updated_by.present?
        issue["lastUpdatedBy"] = {
          "id" => context[:issue].last_updated_by.id,
          "name" => context[:issue].last_updated_by.name
        }
      end

      html =  "\n<script type=\"text/javascript\">\n//<![CDATA[\n"
      html << "ViewCustomize.context.issue = #{issue.to_json};"
      html << "\n//]]>\n</script>\n"

      html << create_view_customize_html(context, ViewCustomize::INSERTION_POSITION_ISSUE_SHOW)

      return html
    end
    
    def view_issues_context_menu_end(context={})
      return "\n" + create_view_customize_html(context, ViewCustomize::INSERTION_POSITION_ISSUES_CONTEXT_MENU)
    end 

    private

    def create_view_customize_html(context, insertion_position)

      view_customize_html_parts = match_customize(context, insertion_position).map {|item|
        to_html(item)
      }
      return view_customize_html_parts.join("\n").html_safe + "\n"

    end

    def match_customize(context, insertion_position)
      path = Redmine::CodesetUtil.replace_invalid_utf8(context[:request].path_info)
      project = context[:project].identifier if context[:project]

      ViewCustomize.all.order(:id).select {|item| target_customize?(path, project, insertion_position, item)}
    end

    def target_customize?(path, project, insertion_position, item)
      return false unless item.available?
      return false unless item.insertion_position == insertion_position 

      if item.path_pattern.present?
        return false unless path =~ Regexp.new(item.path_pattern)
      end

      if item.project_pattern.present?
        return false unless project.present?
        return false unless project =~ Regexp.new(item.project_pattern)
      end

      return true
    end

    def to_html(view_customize)
      
      html = "<!-- view customize id:#{view_customize.id} -->\n"

      if view_customize.is_javascript?
        html << "<script type=\"text/javascript\">\n//<![CDATA[\n"
        html << view_customize.code
        html << "\n//]]>\n</script>"
      elsif view_customize.is_css?
        html << "<style type=\"text/css\">\n"
        html << view_customize.code
        html << "\n</style>"
      elsif view_customize.is_html?
        html << view_customize.code
      end

      return html
    end

    def create_view_customize_context(view_hook_context)

      user = User.current

      if Setting.plugin_view_customize[:create_api_access_key] == "1" and user.api_token.nil?
        # Create API access key
        user.api_key
      end

      context = {
        "user" => {
          "id" => user.id,
          "login" => user.login,
          "admin" => user.admin?,
          "firstname" => user.firstname,
          "lastname" => user.lastname,
          "mail" => user.mail,
          "lastLoginOn" => (user.last_login_on.iso8601 unless user.last_login_on.nil?),
          "groups" => user.groups.map {|group| { "id" => group.id, "name" => group.name }},
          "apiKey" => (user.api_token.value unless user.api_token.nil?),
          "customFields" => user.custom_field_values.map {|field| { "id" => field.custom_field.id, "name" => field.custom_field.name, "value" => field.value }}
        }
      }

      project = view_hook_context[:project]
      if project
        context["project"] = {
          "id" => project.id,
          "identifier" => project.identifier,
          "name" => project.name,
          "roles" => user.roles_for_project(project).map {|role| { "id" => role.id, "name" => role.name }},
          "customFields" => project.custom_field_values.map {|field| { "id" => field.custom_field.id, "name" => field.custom_field.name, "value" => field.value }}
        }
      end

      return context
    end
  end
end
