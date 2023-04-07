class GamesEnrollmentsController < ApplicationController
  MAX_ENTRIES_ALLOWED = 2
  before_action :authenticate_user!
  before_action :set_game
  before_action :set_enrollment, only: [:edit, :update, :destroy]

  def new
    existing_enrollment = @game.games_enrollments.find_by(user_id: current_user.id)
    if existing_enrollment
      flash[:error] = "You have already enrolled in this game."
      redirect_to games_path
    else
      @enrollment = GamesEnrollment.new
    end
  end
  def create
    user_id = current_user.id
    entries = params[:entries].to_i
    existing_enrollments = @game.games_enrollments.where(user_id: user_id)

    if existing_enrollments.present?
      # Scenarios 3 and 4
      update_existing_enrollment(existing_enrollments)
    else
      # Scenarios 1 and 2
      enroll_user(user_id, entries)
    end

    redirect_to @game
  end



  def edit
  end

  def update
    user_id = current_user.id

    # Scenario 5: User decides to remove all his entries and exit the game before the deadline has passed
    if @game.deadline > DateTime.now && params[:entries].to_i == 0
      @enrollment.destroy
      flash[:notice] = "You have successfully exited the game."
      redirect_to games_path
      return
    end

    # Scenarios 3 and 4
    update_existing_enrollment(@enrollment)
    redirect_to @game
  end

  def destroy
    @enrollment.destroy
    flash[:notice] = "You have been removed from the game."
    redirect_to games_path
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_enrollment
    @enrollment = GamesEnrollment.find(params[:id])
    @game = @enrollment.game
  end

  def enrollment_params
    params.require(:games_enrollment).permit(:entries, :entry_id)
  end

  def enroll_user(user_id, entries)
    puts "Entering enroll_user method with user_id: #{user_id}, entries: #{entries}"

    if entries.between?(1, MAX_ENTRIES_ALLOWED) && @game.deadline > DateTime.now
      entries.times do |i|
        puts "Creating enrollment ##{i + 1}"
        @game.games_enrollments.create(user_id: user_id, entry_id: i + 1)
      end
      flash[:notice] = "You have successfully enrolled with #{entries} #{'entry'.pluralize(entries)} for this game."
    elsif @game.deadline <= DateTime.now
      flash[:error] = "The deadline to join this game has passed."
    else
      flash[:error] = "Invalid number of entries."
    end
    puts "Exiting enroll_user method"
  end

  def update_existing_enrollment(existing_enrollments)
    entries = params[:entries].to_i

    if @game.deadline > DateTime.now && entries.between?(1, MAX_ENTRIES_ALLOWED)
      enrollments_to_remove_count = existing_enrollments.count - entries

      if enrollments_to_remove_count > 0
        enrollments_to_remove = existing_enrollments.order(entry_id: :desc).limit(enrollments_to_remove_count)
        enrollments_to_remove.each(&:destroy)
      else
        enrollments_to_add_count = entries - existing_enrollments.count
        enroll_user(current_user.id, enrollments_to_add_count)
      end

      flash[:notice] = "You have successfully updated your enrollment to #{entries} #{'entry'.pluralize(entries)} for this game."
    elsif @game.deadline <= DateTime.now
      flash[:error] = "The deadline to edit your entries has passed."
    else
      flash[:error] = "Invalid number of entries."
    end
  end
end
