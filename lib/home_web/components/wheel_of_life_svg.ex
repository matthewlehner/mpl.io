defmodule HomeWeb.Components.WheelOfLifeSVG do
  @moduledoc """
  A simple Phoenix component that renders a Wheel of Life SVG.
  """
  use Phoenix.Component

  @doc """
  Renders a Wheel of Life SVG.

  ## Attributes

    * `values` - Map of segment values with current/future states (required)

  ## Example

      <WheelOfLifeComponent.wheel_of_life
        values={%{
          career: %{current: 10, future: 10},
          money: %{current: 8, future: 8},
          health: %{current: 8, future: 8},
          growth: %{current: 9, future: 6},
          relationships: %{current: 7, future: 8},
          environment: %{current: 6, future: 8},
          recreation: %{current: 4, future: 8},
          spirituality: %{current: 4, future: 8}
        }}
      />
  """
  attr :values, :map, required: true
  attr :center_x, :integer, default: 200
  attr :center_y, :integer, default: 200
  attr :min_radius, :integer, default: 0
  attr :max_radius, :integer, default: 155

  def wheel_of_life_svg(assigns) do
    assigns =
      assigns
      |> assign_new(:segments, fn %{values: values} -> generate_segments(values) end)
      |> assign_new(:segment_count, fn %{values: values} -> Enum.count(values) end)
      |> assign_new(:degrees_per_segment, fn %{segment_count: segment_count} ->
        360 / segment_count
      end)

    ~H"""
    <svg viewBox="0 0 500 400" xmlns="http://www.w3.org/2000/svg">
      <!-- Scale circles -->
      <g class="scale-circles">
        <circle
          :for={level <- 1..10}
          cx={@center_x}
          cy={@center_y}
          r={calculate_fill_radius(level)}
          class="stroke-[0.8] stroke-gray-200"
          fill="none"
        />
      </g>
      
    <!-- Divider lines -->
      <g class="dividers">
        <%= for i <- 0..(@segment_count - 1) do %>
          <% angle = i * @degrees_per_segment %>
          <% {x1, y1} = polar_to_cartesian(@center_x, @center_y, @min_radius, angle) %>
          <% {x2, y2} = polar_to_cartesian(@center_x, @center_y, @max_radius, angle) %>
          <line
            x1={Float.round(x1, 2)}
            y1={Float.round(y1, 2)}
            x2={Float.round(x2, 2)}
            y2={Float.round(y2, 2)}
            class="stroke-1 stroke-gray-300"
          />
        <% end %>
      </g>
      
    <!-- Segments -->
      <g :for={segment <- @segments} class={"#{segment.name}-segment"}>
        <path d={segment.boundary_path} class="fill-none stroke-1 stroke-gray-300" />
        <path
          d={segment.current_path}
          class="stroke-gray-300 stroke-1 opacity-80"
          fill={segment.color}
        />
        <path
          d={segment.future_path}
          class="stroke-gray-300 stroke-1 opacity-40"
          fill={segment.color}
        />
      </g>
      
    <!-- Labels -->
      <%= for segment <- @segments do %>
        <% {x, y} = calculate_label_position(segment.index) %>
        <text
          x={Float.round(x, 1)}
          y={Float.round(y, 1)}
          text-anchor="middle"
          class="font-sans text-xs text-gray-700 font-medium"
        >
          {segment.label}
        </text>
      <% end %>
      
    <!-- Scale numbers -->
      <text
        :for={level <- 1..10}
        x={@center_x + 5}
        y={@center_y - calculate_fill_radius(level) + 5}
        text-anchor="middle"
        class="font-sans text-[0.5625rem] text-gray-400"
      >
        {level}
      </text>
    </svg>
    """
  end

  # Configuration functions
  defp center_x, do: 200
  defp center_y, do: 200
  defp min_radius, do: 0
  defp max_radius, do: 155
  defp segment_count, do: 8
  defp degrees_per_segment, do: 45

  defp segment_names do
    [
      "career",
      "money",
      "health",
      "growth",
      "relationships",
      "environment",
      "recreation",
      "spirituality"
    ]
  end

  defp segment_labels do
    [
      "Career",
      "Money",
      "Health",
      "Personal Growth",
      "Relationships",
      "Physical Environment",
      "Fun and Recreation",
      "Spirituality"
    ]
  end

  defp segment_colors do
    [
      # career
      "#ffccb3",
      # money
      "#ffffb3",
      # health
      "#b3ffb3",
      # growth
      "#b3fff0",
      # relationships
      "#b3f0ff",
      # environment
      "#e6b3ff",
      # recreation
      "#ffb3ba",
      # spirituality
      "#bfb3ff"
    ]
  end

  # Math functions
  defp degrees_to_radians(degrees), do: degrees * :math.pi() / 180

  defp polar_to_cartesian(center_x, center_y, radius, angle_degrees) do
    angle_radians = degrees_to_radians(angle_degrees)
    x = center_x + radius * :math.cos(angle_radians)
    y = center_y + radius * :math.sin(angle_radians)
    {x, y}
  end

  defp calculate_fill_radius(value, min_radius \\ min_radius(), max_radius \\ max_radius()) do
    min_radius + value / 10 * (max_radius - min_radius)
  end

  defp generate_segment_path(segment_index, radius) do
    start_angle = segment_index * degrees_per_segment()
    end_angle = (segment_index + 1) * degrees_per_segment()

    {x1, y1} = polar_to_cartesian(center_x(), center_y(), radius, start_angle)
    {x2, y2} = polar_to_cartesian(center_x(), center_y(), radius, end_angle)

    x1 = Float.round(x1, 2)
    y1 = Float.round(y1, 2)
    x2 = Float.round(x2, 2)
    y2 = Float.round(y2, 2)

    "M #{center_x()} #{center_y()} L #{x1} #{y1} A #{radius} #{radius} 0 0 1 #{x2} #{y2} Z"
  end

  defp calculate_label_position(segment_index) do
    angle = segment_index * degrees_per_segment() + degrees_per_segment() / 2
    label_radius = max_radius() + 30
    polar_to_cartesian(center_x(), center_y(), label_radius, angle)
  end

  defp generate_segments(values) do
    0..(segment_count() - 1)
    |> Enum.map(fn i ->
      segment_name = Enum.at(segment_names(), i)
      segment_atom = String.to_existing_atom(segment_name)
      segment_label = Enum.at(segment_labels(), i)
      segment_color = Enum.at(segment_colors(), i)

      segment_values = Map.get(values, segment_atom, %{current: 0, future: 0})
      current_value = segment_values.current
      future_value = segment_values.future

      current_radius = calculate_fill_radius(current_value)
      future_radius = calculate_fill_radius(future_value)

      %{
        index: i,
        name: segment_name,
        label: segment_label,
        color: segment_color,
        current_path: generate_segment_path(i, current_radius),
        future_path: generate_segment_path(i, future_radius),
        boundary_path: generate_segment_path(i, max_radius())
      }
    end)
  end
end
