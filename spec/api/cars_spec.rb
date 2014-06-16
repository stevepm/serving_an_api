require 'rails_helper'

describe 'Car API' do

  describe 'GET /cars' do
    it 'returns a list of cars' do
      ford = create_make(:name=> "Ford")
      chevy = create_make(:name=> "Chevy")
      blue_four_door = create_car(:color => "blue",
                                  :doors => 4,
                                  :purchased_on=> "2013-01-01",
                                  :make=> ford)
      green_two_door = create_car(:color=> "green",
                                  :doors=> 2,
                                  :purchased_on=> "1991-02-02",
                                  :make=> chevy)

      get '/cars',{}, {'Accept' => 'application/json'}

      expected_response = {
        "_links"=> {
          "self"=> {
            "href"=> "/cars"
          }
        },
        "_embedded"=> {
          "cars"=> [
            {
              "_links"=> {
                "self"=> {
                  "href"=> "/cars/#{blue_four_door.id}"
                },
                "make"=> {
                  "href"=> "/makes/#{ford.id}"
                }
              },
              "id"=> blue_four_door.id,
              "color"=> "blue",
              "doors"=> 4,
              "purchased_on"=> "2013-01-01T00:00:00.000Z"
            },
            {
              "_links"=> {
                "self"=> {
                  "href"=> "/cars/#{green_two_door.id}"
                },
                "make"=> {
                  "href"=> "/makes/#{chevy.id}"
                }
              },
              "id"=> green_two_door.id,
              "color"=> "green",
              "doors"=> 2,
              "purchased_on"=> "1991-02-02T00:00:00.000Z"
            }
          ]
        }
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)

    end
  end

  describe '/get/cars/1' do
    it 'will return a correct json' do
      ford = create_make(:name => "Ford")
      blue_four_door = create_car(:color => "blue",
                                  :doors => 4,
                                  :purchased_on=> "2013-01-01",
                                  :make => ford)
      get "/cars/#{blue_four_door.id}", {}, {'Accept' => 'application/json'}

      expected_response = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{blue_four_door.id}"
          },
          "make" => {
            "href" => "/makes/#{ford.id}"
          }
        },
        "id" => blue_four_door.id,
        "color" => "blue",
        "doors" => 4,
        "purchased_on" => "2013-01-01T00:00:00.000Z"
      }
      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)

      get '/cars/2', {}, {'Accept' => 'application/json'}
      expect(response.code.to_i).to eq 404

    end
  end

  describe '/post/cars' do
    it 'posts to cars' do
      ford = create_make(:name => "Ford")
      params = {:car => {:color => "blue",
                         :doors => 4,
                         :purchased_on => Date.today,
                         :make => ford}}
      post "/cars",
        params.to_json,
        {'CONTENT_TYPE' => 'application/json', 'Accept' => 'application/json' }

      car = Car.last

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{car.id}"
          },
          "make" => {
            "href" => "/makes/#{ford.id}"
          }
        },
        "id" => car.id,
        "color" => "blue",
        "doors" => 4,
        "purchased_on" => "2014-06-16T00:00:00.000Z"
      }

      expect(JSON.parse(response.body)).to eq expected
    end
  end



end
