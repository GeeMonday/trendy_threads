ActiveAdmin.register StaticPage do
  permit_params :title, :content

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text # Use standard text area for multi-line text fields
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :content do |page|
      truncate(page.content, length: 100)  # Truncate content for better display in index
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row :content do |page|
        raw page.content  # Display raw HTML content
      end
    end
  end
end
