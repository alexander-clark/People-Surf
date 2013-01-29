class SubjectsController < ApplicationController
  
  def index
    @title = "All Subjects"
    @subjects = Subject.paginate(:page => params[:page])
  end
  
  def show
    @subject = Subject.find(params[:id])
    @title = @subject.name
  end
  
  def new
    @title = "New subject"
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new(params[:subject])
    if @subject.save
      flash[:success] = "Subject created"
      @title = "All Subjects"
      @subjects = Subject.paginate(:page => params[:page])
      render 'index'
    else
      @title = "New subject"
      render 'new'
    end
  end
  
  def edit
    @subject = Subject.find(params[:id])
    @title = "Edit subject"
  end
  
  def update
    @subject = Subject.find(params[:id])
    #@subs = @user.subject_ids
    if @subject.update_attributes(params[:subject])
      flash[:success] = "Subject updated."
      redirect_to @subject
    else
      @title = "Edit subject"
      render 'edit'
    end
  end
  
  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Subject deleted"
    redirect_to subjects_path
  end
end
