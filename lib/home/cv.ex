defmodule Home.CV do
  @moduledoc """
    Functionality related to my curriculum vitae/work experience.
  """

  use HomeWeb, :html

  @personal_readme """
                     For over 20 years, I've worked in the tech industry. I've founded successful
                     businesses and worked in high-growth organizations as an individual contributor and
                     executive. This breadth of experience has helped me understand where my strengths and
                     passion intersect. I'm happiest and most effective when working as an individual
                     contributor in a people-first organization.

                     I bring a mix of product, engineering, and leadership skills to my day-to-day, and love to
                     ship customer-focused solutions while mentoring and learning from my colleagues. I like
                     being a part of a team and thrive when I feel like I am helping to build resilient,
                     high-performing teams where we all share in our successes and learn from our failures.

                     I'm a full-stack developer. I'm just as happy optimizing database queries or writing yaml
                     for a K8S cluster as I am talking with design about vertical rhythm and building UIs that
                     delight.

                     My preferred tech stack is Elixir/Phoenix/LiveView with Tailwind CSS, some JavaScript, and
                     Postgres deployed to Fly.io or a managed K8S cluster. I've been working with Elixir for
                     almost a decade now. I've also worked extensively with Ruby on Rails, React, Next.js, and
                     TypeScript and managed infrastructure on AWS, GCP, and bare metal with Terraform and
                     Ansible.

                     I'm a great fit in a small, autonomous team that is close to its customers and has a
                     mission to ship great work.
                   """
                   |> Earmark.as_html!()

  def readme, do: @personal_readme

  def roles do
    [
      %{
        company: "Hiive",
        title: "Principal Software Engineer",
        logo: ~p"/images/logos/hiive.svg",
        start: "2024",
        end: %{
          label: "Present",
          dateTime: 2025
        }
      },
      %{
        company: "Fly.io",
        title: "Staff Developer",
        logo: ~p"/images/logos/flyio.svg",
        start: "2023",
        end: "2024"
      },
      %{
        company: "Fluorescent Design Inc.",
        title: "CTO (Fractional)",
        logo: ~p"/images/logos/fluorescent.svg",
        start: "2021",
        end: "2024"
      },
      %{
        company: "OneFeather",
        title: "CTO & Technical Co-founder",
        logo: ~p"/images/logos/onefeather.svg",
        start: "2019",
        end: "2023"
      },
      %{
        company: "Pixel Union",
        title: "Director of Engineering & Product",
        logo: ~p"/images/logos/pixelunion.svg",
        start: "2017",
        end: "2019"
      },
      %{
        company: "OneFeather",
        title: "Founding Developer",
        logo: ~p"/images/logos/onefeather.svg",
        start: "2014",
        end: "2017"
      },
      %{
        company: "Scripps Health",
        title: "Senior Frontend Engineer",
        logo: ~p"/images/logos/scripps.svg",
        start: "2011",
        end: "2014"
      },
      %{
        company: "MPL Software",
        title: "Principal",
        logo: ~p"/images/logos/mpl.svg",
        start: "2011",
        end: "2017"
      }
    ]
  end
end
