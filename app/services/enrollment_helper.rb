module EnrollmentHelper
  def enroll_user(user_id, entries)
    if entries.between?(1, Game::MAX_ENTRIES_PER_USER) && @game.deadline > DateTime.now - 2
      entries.times do |i|
        @game.games_enrollments.create(user_id: user_id, entry_id: i + 1)
      end
      @game.update_entries_count
      flash[:notice] = "You have successfully enrolled with #{entries} #{'entry'.pluralize(entries)} for this game."
    elsif @game.deadline <= DateTime.now
      flash[:error] = "The deadline to join this game has passed."
    else
      flash[:error] = "Invalid number of entries."
    end
  end

  def update_existing_enrollment(existing_enrollments)
    entries = params[:entries].to_i

    if @game.deadline > DateTime.now && entries.between?(1, Game::MAX_ENTRIES_PER_USER)
      #how many enrollments need to be removed in order to make room for the new enrollments
      enrollments_to_remove_count = existing_enrollments.count - entries

      if enrollments_to_remove_count > 0
        enrollments_to_remove = existing_enrollments.order(entry_id: :desc).limit(enrollments_to_remove_count)
        enrollments_to_remove.each(&:destroy)
      else
        enrollments_to_add_count = entries - existing_enrollments.count
        enroll_user(current_user.id, enrollments_to_add_count)
      end

      # Update the game entries count
      @game.update_entries_count

      flash[:notice] = "You have successfully updated your enrollment to #{entries} #{'entry'.pluralize(entries)} for this game."
    elsif @game.deadline <= DateTime.now
      flash[:error] = "The deadline to edit your entries has passed."
    else
      flash[:error] = "Invalid number of entries."
    end
  end

  def destroy
  # Remove the enrollment
    @enrollment.destroy

    # Update the game entries count
    @game.update_entries_count

    flash[:notice] = "You have been removed from the game."
    redirect_to game_setup_path
  end
end

