defmodule Atomizer.Scraper.FunimationTest do
  use ExUnit.Case

  alias Atomizer.Scraper.Funimation
  alias Atomizer.Episode
  alias Atomizer.Provider
  alias Atomizer.Show

  import Mock

  # ----------------------------------------------------------------------------
  # Setup and data providers
  # ----------------------------------------------------------------------------

  setup_with_mocks([
    {Tesla, [],
     [
       get: fn _, path, _ ->
         cond do
           String.contains?(path, "/source/funimation/search/auto") ->
             {:ok, %{status: 200, body: search_response()}}

           String.contains?(path, "/funimation/episodes") ->
             {:ok, %{status: 200, body: episodes_response()}}
         end
       end,
       client: fn _, _ -> %{} end
     ]}
  ]) do
    :ok
  end

  defp search_response do
    "../../support/data/funimation-search-response.json"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Jason.decode!()
  end

  defp episodes_response do
    "../../support/data/funimation-episodes-response.json"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Jason.decode!()
  end

  # ----------------------------------------------------------------------------
  # Tests
  # ----------------------------------------------------------------------------

  test "scrape/1 maps json response to Show struct" do
    actual =
      Funimation.scrape("https://www.funimation.com/shows/mushoku-tensei-jobless-reincarnation/")

    expected = %Show{
      id: "1311428",
      title: "Mushoku Tensei: Jobless Reincarnation",
      slug: "mushoku-tensei-jobless-reincarnation",
      description:
        "When a 34-year-old underachiever gets run over by a bus, his story doesn't end there. Reincarnated as an infant, Rudy will use newfound courage, friends, and magical abilities to embark on an epic adventure!",
      ratings: "TV14",
      url: "https://funimation.com/shows/mushoku-tensei-jobless-reincarnation",
      cover:
        "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_ShowDetailHeaderDesktop_6ca17cd7-2001-445a-afe2-cda34c93bbef.jpg",
      keyart:
        "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_ShowKeyart_106133ec-f4e2-4d0f-9027-d18630b60d26.jpg",
      thumbnail:
        "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_ShowThumbnail_a345fb76-70b2-4b1e-a4d1-bd567cc91c20.jpg",
      provider: %Provider{
        accent_color: "410099",
        logo: "https://upload.wikimedia.org/wikipedia/commons/4/47/Funimation_2016.svg",
        name: "Funimation",
        slug: "funimation",
        url: "https://funimation.com"
      },
      episodes: [
        %Episode{
          id: 1_321_629,
          number: "4",
          title: "Emergency Family Meeting",
          slug: "emergency-family-meeting",
          runtime: "23:40",
          season: "1",
          star_rating: 4.875178316690442,
          synopsis:
            "The Greyrat family is overjoyed when Zenith announces that she's pregnant with a second child, but the mood takes a dour turn when Lilia reveals that she is also pregnant and Paul is the father. Will this be the end of Rudy's happy family?",
          thumbnail:
            "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_KeyArt-OfficialVideoImage_e7c043d4-1d89-4164-a375-ea78532be644.jpg",
          timestamp: "2021-01-31 15:59:59+00:00",
          url:
            "https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/emergency-family-meeting/simulcast"
        },
        %Episode{
          id: 1_321_613,
          number: "3",
          title: "A Friend",
          slug: "a-friend",
          runtime: "23:40",
          season: "1",
          star_rating: 4.9019488428745435,
          synopsis:
            "Rudy begins to explore the village and rescues a green-haired child from a group of bullies. The two grow close practicing magic, but is there more to Rudy's new friend than he thinks?",
          thumbnail:
            "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315890/Japanese/2315890_Japanese_KeyArt-OfficialVideoImage_f1cd02a3-46e8-415d-b93b-ea5507da4630.jpg",
          timestamp: "2021-01-24 15:59:59+00:00",
          url:
            "https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/a-friend/simulcast"
        },
        %Episode{
          id: 1_321_632,
          number: "2",
          title: "Master",
          slug: "master",
          runtime: "23:40",
          season: "1",
          star_rating: 4.8091168091168095,
          synopsis:
            "Rudy begins training with his new magic tutor and learning swordsmanship from his father. He makes rapid progress, but traumatic memories from his past life leave him to afraid to go outside. Is his second chance already doomed to failure?",
          thumbnail:
            "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315882/Japanese/2315882_Japanese_KeyArt-OfficialVideoImage_c25e5c00-d75f-4596-914c-8b54621eeda8.jpg",
          timestamp: "2021-01-17 16:00:00+00:00",
          url:
            "https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/master/simulcast"
        },
        %Episode{
          id: 1_311_430,
          number: "1",
          title: "Jobless Reincarnation",
          slug: "jobless-reincarnation",
          runtime: "23:40",
          season: "1",
          star_rating: 4.8979957050823195,
          synopsis:
            "A 34-year-old unemployed recluse get hit by a truck... and wakes up as a newborn baby in a fantasy world! With loving parents, a lifetime of regrets, and a beginner's magic textbook, he sets out to make the most of his second chance at life.",
          thumbnail:
            "https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315884/Japanese/2315884_Japanese_KeyArt-OfficialVideoImage_d2d859bc-e06e-4a91-9402-5a2623a1d414.jpg",
          timestamp: "2021-01-10 16:00:00+00:00",
          url:
            "https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/jobless-reincarnation/simulcast"
        }
      ]
    }

    assert actual == expected
  end
end
