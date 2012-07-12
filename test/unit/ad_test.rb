require 'test_helper'

class AdTest < ActiveSupport::TestCase
	setup do
		@a1 = ads(:a1)
	end

	test "favorites" do
		user1 = users(:uva)

		assert !@a1.favorite?(user1.id)

		@a1.mark_favorite! user1.id
		assert @a1.favorite?(user1.id)

		@a1.unmark_favorite! user1.id
		assert !@a1.favorite?(user1.id)
	end
	
	test "ad rating" do
		user1 = users(:uva)

		assert_nil @a1.user_rating(user1.id)

		@a1.rate! user1.id, 3
		assert_equal 3, @a1.user_rating(user1.id)
		
		@a1.rate! user1.id, 4
		assert_equal 4, @a1.user_rating(user1.id)

		assert_raise(Ad::ArgumentError) { @a1.rate! user1.id, 0 }
		assert_equal 4, @a1.user_rating(user1.id)
		
		assert_raise(Ad::ArgumentError) { @a1.rate! user1.id, -1 }
		assert_raise(Ad::ArgumentError) { @a1.rate! user1.id, 6 }
		assert_raise(Ad::ArgumentError) { @a1.rate! user1.id, nil }
	end
	
	test "average ad rating" do
    assert_nil @a1.average_rate

	  @a1.rate! users(:uva), 3
	  assert_in_delta 3.0, @a1.average_rate, 0.001
	  
	  @a1.rate! users(:ray).id, 4
	  assert_in_delta 3.5, @a1.average_rate, 0.001
	  
	  @a1.rate! users(:grelhas).id, 1
	  assert_in_delta (8.0 / 3.0), @a1.average_rate, 0.001
	  
	  @a1.rate! users(:ray).id, 5
	  assert_in_delta 3.0, @a1.average_rate, 0.001
	end
	
	test "final evaluation" do
	  user1 = users(:uva)
	  
	  # check initial state
	  assert_nil @a1.final_eval_user_id
	  assert_nil @a1.final_eval
	  assert @a1.open?
	  
	  # test use of set_final_eval_user before closing the ad
	  assert_raise(Ad::AdNotClosedError) { @a1.set_final_eval_user! user1.id }
	  assert_nil @a1.final_eval_user_id
	  
	  # close the ad
	  @a1.close!
	  
	  # test use of do_final_eval before setting the user id
	  assert_raise(Ad::EvalUserNotDefinedError) { @a1.do_final_eval! user1.id, 4 }
	  assert_nil @a1.final_eval
	  
	  # test correct use of set_final_eval_user
	  @a1.set_final_eval_user! user1.id
	  assert_equal user1.id, @a1.final_eval_user_id
	  assert_nil @a1.final_eval
	  
	  # test incorrect use of set_final_eval_user
	  assert_raise(Ad::UserAlreadyDefinedError) { @a1.set_final_eval_user! users(:ray).id }
	  assert_equal user1.id, @a1.final_eval_user_id
	  assert_raise(Ad::UserAlreadyDefinedError) { @a1.set_final_eval_user! user1.id }
	  
	  # test unauthorized use of do_final_eval
	  assert_raise(Ad::UnauthorizedUserException) { @a1.do_final_eval! users(:ray).id, 4 }
	  assert_nil @a1.final_eval
	  
	  # test correct use of do_final_eval
	  @a1.do_final_eval! user1.id, 4
	  assert_equal 4, @a1.final_eval
	  
	  # test posterior use of do_final_eval
	  assert_raise(Ad::EvalAlreadyDoneError, Ad::UnauthorizedUserException) { @a1.do_final_eval! users(:ray).id, 4 }
	  assert_equal 4, @a1.final_eval
	  assert_raise(Ad::EvalAlreadyDoneError) { @a1.do_final_eval! user1.id, 4 }
	end

  test "user rating" do
    grelhas_id = users(:grelhas).id
    assert_nil User.find(grelhas_id).rate

    @a1.close!
    @a1.set_final_eval_user! users(:uva).id
    @a1.do_final_eval! users(:uva).id, 4

    assert_not_nil User.find(grelhas_id).rate
    assert_in_delta 4.0, User.find(grelhas_id).rate, 0.001

    ads(:a5).close!
    ads(:a5).set_final_eval_user! users(:ray).id
    ads(:a5).do_final_eval! users(:ray).id, 3

    assert_in_delta 3.5, User.find(grelhas_id).rate, 0.001
  end

  test "relevance factor" do
    Ad.RELEVANCE_USER_SCALE = 3

    assert_equal 0, @a1.relevance_factor, "initial assert failed"
    
    @a1.rate! users(:uva), 4
    assert_in_delta 0.5 * (1.0/3), @a1.relevance_factor, 0.001, "assert 1 failed"

    @a1.rate! users(:ray), 5
    assert_in_delta 0.75 * (2.0/3), @a1.relevance_factor, 0.001, "assert 2 failed"

    @a1.rate! users(:grelhas), 3
    assert_in_delta 0.5, @a1.relevance_factor, 0.001, "assert 3 failed"

    @a1.rate! users(:vashu), 1
    avg_ad_rate = [0.5, 1, 0, -1].inject(0.0) { |result, el| result + el } / 4.0 # 0.125
    assert_in_delta avg_ad_rate, @a1.relevance_factor, 0.001, "assert 4 failed"

    @a1.close!
    @a1.set_final_eval_user! users(:ray).id
    @a1.do_final_eval! users(:ray).id, 4
    rel = (1.0/5) * 0.5 * (1.0/3) + (4.0/5) * avg_ad_rate # 0.133
    assert_in_delta rel, @a1.relevance_factor, 0.001, "assert 5 failed"
  end

	test "relevance" do
    ad1_rel = @a1.relevance
    assert ad1_rel > 0

    ad2_rel = ads(:a2).relevance
    assert ad2_rel > 0

    # TODO to change when the relevance algorithm is defined
    assert ad2_rel > ad1_rel
  end
  
  test "opened" do
    arr = Ad.all_opened
    assert_equal 4, arr.length
    arr.each do |a|
      assert a.open?
    end 
  end

  # TODO to change when the relevance algorithm is defined
  test "most relevant" do
    arr = Ad.most_relevant 3, nil
    assert_equal [ads(:a3), ads(:a2), @a1], arr

    arr = Ad.most_relevant 5, nil
    assert_equal [ads(:a3), ads(:a2), @a1, ads(:a5)], arr

    arr = Ad.most_relevant 1, nil
    assert_equal [ads(:a3)], arr

    arr = Ad.most_relevant 0, nil
    assert_equal [], arr

    arr = Ad.most_relevant -1, nil
    assert_nil arr

    arr = Ad.most_relevant nil, nil
    assert_nil arr
  end

  # TODO change order of results when the relevance algorithm is defined
  test "search" do
  	arr = Ad.search_text "Porto", 1, nil
    assert_equal [ads(:a3)], arr, "Search in tags from opened ads only failed"
    
  	arr = Ad.search_text "world", 1, nil
    assert_equal [@a1], arr, "Search in a substring of a tag failed"
    
    arr = Ad.search_text "universitario", 1, nil
    assert_equal [ads(:a3)], arr, "Case and accent insensivive search (input text only) in title failed"
    
    arr = Ad.search_text "feup", 1, nil
    assert_equal [ads(:a3), ads(:a2)], arr, "Search with multiple results, ordered by relevance, failed"
    
    arr = Ad.search_text "t2 primeiro", 1, nil
    assert_equal [ads(:a3), @a1], arr, "Search with multiple keywords failed"

    Ad.per_page = 1
    arr = Ad.search_text "t2 primeiro", 1, nil
    assert_equal [ads(:a3)], arr, "Search with limit number of results failed"
    Ad.per_page = 10
    
    arr = Ad.search_text "not_in_tags", 1, nil
    assert arr.empty?, "Search with empty results failed"
    
    arr = Ad.search_text "a", 100, nil
    assert arr.empty?, "Search with empty results failed"
    
    arr = Ad.search_text nil, 1, nil
    assert_equal [ads(:a3),ads(:a2),ads(:a1),ads(:a5)], arr, "Search with invalid inputs failed"
    
    arr = Ad.search_text "a", -1, nil
    assert_nil arr, "Search with invalid inputs failed"
    
    arr = Ad.search_text "a", nil, nil
    assert_nil arr, "Search with invalid inputs failed"
  end
  
  test "close" do
		assert @a1.open?
		
		@a1.close!
		assert !@a1.open?
		
		@a1.open!
		assert @a1.open?
		
		@a1.close_permanently!
		assert !@a1.open?
	
		assert_raise(Ad::CannotOpenAdError) { @a1.open! }
		assert !@a1.open?
  end
end
