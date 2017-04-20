package guide

class MerGuideController {
//    def header = {
//        render(view: "guideHeader",params:params)
//    }
    def index = {
        render(view: "guideHeader",params:params)
    }
    def guide = {
        render(view: "guide",params:params)
    }
    def bulk = {
        render(view: "bulk",params:params)
    }
}
