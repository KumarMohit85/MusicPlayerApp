import uuid
import bcrypt
from fastapi import APIRouter, Depends, HTTPException, Header
import jwt
from database import get_db
from middlewares.auth_middlewares import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin
router= APIRouter()

@router.post('/signup',status_code=201)
def signup_user(user: UserCreate, db:Session= Depends(get_db)):
   # extract the data thats coming from request
   print(user.name) 
   print(user.email)
   print(user.password)
   # check if the user already exists in db
   user_db= db.query(User).filter(User.email==user.email).first()

   if  user_db:
      raise HTTPException(400,'Email already exists')
   
   #new user instance
   hashed_pw= bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
   user_db= User(id=str(uuid.uuid4()),name=user.name,email=user.email,password= hashed_pw)
   # add the user to the db
   db.add(user_db)
   db.commit()
   db.refresh(user_db)
   return user_db


@router.post('/login')
def login_user(user: UserLogin, db:Session=Depends(get_db)):
   #check if user with same email already exists or not
   user_db= db.query(User).filter(User.email==user.email).first()
   if not user_db:
       raise HTTPException(400,'User with this email does not exist, create account first' )
   #password matching or not
   is_match= bcrypt.checkpw(user.password.encode(),user_db.password)

   if not is_match:
      raise HTTPException(400,'Incorrect Password')
   
   token= jwt.encode({'id':user_db.id}, 'password_key')
   return {'token':token,'user':user_db}
   

@router.get('/')
def current_user_data(db:Session= Depends(get_db), x_auth_token= Header(),user_dict=Depends(auth_middleware)):
    user = db.query(User).filter(User.id==user_dict['uid']).first()
    if not user:
       raise HTTPException(404,'user not found')
   
    return user
   