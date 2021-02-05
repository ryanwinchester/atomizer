defmodule AtomizerWeb.FeedControllerTest do
  use AtomizerWeb.ConnCase

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

  defp clean_whitespace(text) do
    String.replace(text, ~r/\s{2,}/, " ")
  end

  # ----------------------------------------------------------------------------
  # Tests
  # ----------------------------------------------------------------------------

  test "/feed with funimation URL renders feed", %{conn: conn} do
    params = %{show: "https://www.funimation.com/shows/mushoku-tensei-jobless-reincarnation/"}
    resp = get(conn, Routes.feed_path(conn, :index), params)

    assert xml = xml_response(resp, 200)

    expected = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" xmlns:webfeeds="http://webfeeds.org/rss/1.0">
      <title>Mushoku Tensei: Jobless Reincarnation</title>
      <link href="https://atomizer.gigalixirapp.com/feed/?show=https://funimation.com/shows/mushoku-tensei-jobless-reincarnation" rel="self"/>
      <link href="https://funimation.com/shows/mushoku-tensei-jobless-reincarnation"/>
      <updated>2021-01-31T15:59:59Z</updated>
      <id>https://funimation.com/shows/mushoku-tensei-jobless-reincarnation</id>
      <author>
        <name>Funimation</name>
        <uri>https://funimation.com</uri>
      </author>

      <webfeeds:cover image="https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_ShowDetailHeaderDesktop_6ca17cd7-2001-445a-afe2-cda34c93bbef.jpg" />
      <webfeeds:icon>https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_ShowThumbnail_a345fb76-70b2-4b1e-a4d1-bd567cc91c20.jpg</webfeeds:icon>
      <webfeeds:logo>https://upload.wikimedia.org/wikipedia/commons/4/47/Funimation_2016.svg</webfeeds:logo>
      <webfeeds:accentColor>211533</webfeeds:accentColor>
      <webfeeds:related layout="card" target="browser"/>

      <entry>
        <title>Episode 4 - Emergency Family Meeting</title>
        <link rel="alternate" href="https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/emergency-family-meeting/simulcast"/>
        <id>https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/emergency-family-meeting/simulcast</id>
        <content type="html">
          &lt;img src=&quot;https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315892/Japanese/2315892_Japanese_KeyArt-OfficialVideoImage_e7c043d4-1d89-4164-a375-ea78532be644.jpg&quot; class=&quot;webfeedsFeaturedVisual&quot; style=&quot;width:100%;display:block;&quot;&gt;\n&lt;p&gt;The Greyrat family is overjoyed when Zenith announces that she&apos;s pregnant with a second child, but the mood takes a dour turn when Lilia reveals that she is also pregnant and Paul is the father. Will this be the end of Rudy&apos;s happy family?&lt;/p&gt;
        </content>
        <summary type="text">The Greyrat family is overjoyed when Zenith announces that she's pregnant with a second child, but the mood takes a dour turn when Lilia reveals that she is also pregnant and Paul is the father. Will this be the end of Rudy's happy family?</summary>
        <updated>2021-01-31T15:59:59Z</updated>
        <published>2021-01-31T15:59:59Z</published>
      </entry>

      <entry>
        <title>Episode 3 - A Friend</title>
        <link rel="alternate" href="https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/a-friend/simulcast"/>
        <id>https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/a-friend/simulcast</id>
        <content type="html">
          &lt;img src=&quot;https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315890/Japanese/2315890_Japanese_KeyArt-OfficialVideoImage_f1cd02a3-46e8-415d-b93b-ea5507da4630.jpg&quot; class=&quot;webfeedsFeaturedVisual&quot; style=&quot;width:100%;display:block;&quot;&gt;\n&lt;p&gt;Rudy begins to explore the village and rescues a green-haired child from a group of bullies. The two grow close practicing magic, but is there more to Rudy&apos;s new friend than he thinks?&lt;/p&gt;
        </content>
        <summary type="text">Rudy begins to explore the village and rescues a green-haired child from a group of bullies. The two grow close practicing magic, but is there more to Rudy's new friend than he thinks?</summary>
        <updated>2021-01-24T15:59:59Z</updated>
        <published>2021-01-24T15:59:59Z</published>
      </entry>

      <entry>
        <title>Episode 2 - Master</title>
        <link rel="alternate" href="https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/master/simulcast"/>
        <id>https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/master/simulcast</id>
        <content type="html">
          &lt;img src=&quot;https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315882/Japanese/2315882_Japanese_KeyArt-OfficialVideoImage_c25e5c00-d75f-4596-914c-8b54621eeda8.jpg&quot; class=&quot;webfeedsFeaturedVisual&quot; style=&quot;width:100%;display:block;&quot;&gt;\n&lt;p&gt;Rudy begins training with his new magic tutor and learning swordsmanship from his father. He makes rapid progress, but traumatic memories from his past life leave him to afraid to go outside. Is his second chance already doomed to failure?&lt;/p&gt;
        </content>
        <summary type="text">Rudy begins training with his new magic tutor and learning swordsmanship from his father. He makes rapid progress, but traumatic memories from his past life leave him to afraid to go outside. Is his second chance already doomed to failure?</summary>
        <updated>2021-01-17T16:00:00Z</updated>
        <published>2021-01-17T16:00:00Z</published>
      </entry>

      <entry>
        <title>Episode 1 - Jobless Reincarnation</title>
        <link rel="alternate" href="https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/jobless-reincarnation/simulcast"/>
        <id>https://funimation.com/shows/mushoku-tensei-jobless-reincarnation/jobless-reincarnation/simulcast</id>
        <content type="html">
          &lt;img src=&quot;https://derf9v1xhwwx1.cloudfront.net/image/upload/oth/FunimationStoreFront/2315884/Japanese/2315884_Japanese_KeyArt-OfficialVideoImage_d2d859bc-e06e-4a91-9402-5a2623a1d414.jpg&quot; class=&quot;webfeedsFeaturedVisual&quot; style=&quot;width:100%;display:block;&quot;&gt;\n&lt;p&gt;A 34-year-old unemployed recluse get hit by a truck... and wakes up as a newborn baby in a fantasy world! With loving parents, a lifetime of regrets, and a beginner&apos;s magic textbook, he sets out to make the most of his second chance at life.&lt;/p&gt;
        </content>
        <summary type="text">A 34-year-old unemployed recluse get hit by a truck... and wakes up as a newborn baby in a fantasy world! With loving parents, a lifetime of regrets, and a beginner's magic textbook, he sets out to make the most of his second chance at life.</summary>
        <updated>2021-01-10T16:00:00Z</updated>
        <published>2021-01-10T16:00:00Z</published>
      </entry>

    </feed>
    """

    assert clean_whitespace(xml) == clean_whitespace(expected)
  end
end
