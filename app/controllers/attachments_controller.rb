class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])

    if current_user and current_user.author_of?(@attachment.attachable)
      @attachment.delete
    end
  end
end
