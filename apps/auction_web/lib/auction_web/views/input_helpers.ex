defmodule YourApp.InputHelpers do
  use Phoenix.HTML

  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      error = YourApp.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      is_nil(form.source.action) -> ""
      # The field has error
      form.errors[field] -> "has-error"
      # The field is blank
      input_value(form, field) in ["", nil] -> ""
      # The field was filled successfully
      true -> "has-success"
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
