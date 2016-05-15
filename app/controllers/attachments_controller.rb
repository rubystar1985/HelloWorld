class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.delete
  end
end
