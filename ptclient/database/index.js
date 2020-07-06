import { Database } from '@vuex-orm/core'
import CtSearch from '@/models/ormSearchUiToCT'
import CtLifeCycle from '@/models/ormCtLifeCycle'
import User from '@/models/user'
import Todo from '@/models/Todo'
import Patient from '@/models/patient'
import Rex from '@/models/Recommendation'
import Dx from '@/models/Dx'
import Goal from '@/models/Goal'
import Scr from '@/models/Screening'

const database = new Database()

database.register(User)
database.register(Todo)
database.register(Patient)
database.register(Rex)
database.register(Dx)
database.register(Goal)
database.register(Scr)
database.register(CtSearch)
database.register(CtLifeCycle)

export default database
