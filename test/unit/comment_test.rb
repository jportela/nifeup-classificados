require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
		@c1 = comments(:c1)
	end

  test "report" do
    user1 = users(:uva)

    assert !@c1.reported?
    assert comments(:c3).reported?
    assert_equal [comments(:c3)], Comment.all_reported

    @c1.report! user1.id
    assert @c1.reported?
    assert_equal [@c1, comments(:c3)], Comment.all_reported.sort {|c| c.id }
    assert_raise(Comment::AlreadyReportedError) { @c1.report! user1.id }

    @c1.report! users(:ray).id, "Razao do comentario"
  end

  test "multiple reports" do
    Comment.set_report_limit 3

    assert !@c1.reported?, 'Not reported'
    assert !@c1.badly_reported?, 'Not badly reported'

    @c1.report! users(:uva).id
    assert @c1.reported?, 'Reported by uva'
    assert !@c1.badly_reported?, 'Not badly reported'

    @c1.report! users(:ray).id
    assert @c1.reported?, 'Reported by ray'
    assert !@c1.badly_reported?

    @c1.report! users(:grelhas).id
    assert @c1.reported?, 'Reported by grelhas'
    assert @c1.badly_reported?
  end
end
