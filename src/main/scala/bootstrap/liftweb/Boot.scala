package bootstrap.liftweb

import _root_.net.liftweb.util._
import _root_.net.liftweb.http._
import _root_.net.liftweb.http.provider._
import _root_.net.liftweb.sitemap._
import _root_.net.liftweb.sitemap.Loc._
import Helpers._
import _root_.net.liftweb.mapper.{DB, ConnectionManager, Schemifier, DefaultConnectionIdentifier, ConnectionIdentifier}
import _root_.java.sql.{Connection, DriverManager}


/**
 * A class that's instantiated early and run.  It allows the application
 * to modify lift's environment
 */
class Boot {
  def boot {
    // where to search snippet
    LiftRules.addToPackages("com.liftcode")

    // Build SiteMap
    val entries = Menu(Loc("Home", List("index"), "Home")) ::
    Menu(Loc("Cappucinno", List("capp"), "Cappuccino")) ::
    Nil

    LiftRules.setSiteMap(SiteMap(entries:_*))

    /*
     * Show the spinny image when an Ajax call starts
     */
    LiftRules.ajaxStart =
    Full(() => LiftRules.jsArtifacts.show("ajax-loader").cmd)

    /*
     * Make the spinny image go away when it ends
     */
    LiftRules.ajaxEnd =
    Full(() => LiftRules.jsArtifacts.hide("ajax-loader").cmd)

    LiftRules.early.append(makeUtf8)

    LiftRules.useXhtmlMimeType = false

    // We serve Cappuccino files with wicked friendly
    // mime types
    LiftRules.liftRequest.append {
      case Req( _, "j", GetRequest) => true
      case Req( _, "sj", GetRequest) => true
      case Req( _, "plist", GetRequest) => true
    }

    LiftRules.statelessDispatchTable.prepend {
      case r @ Req( _, "j", GetRequest) => ObjJServer.serve(r)
      case r @ Req( _, "sj", GetRequest) => ObjJServer.serve(r)
      case r @ Req( _, "plist", GetRequest) => ObjJServer.serve(r)
    }
  }

  /**
   * Force the request to be UTF-8
   */
  private def makeUtf8(req: HTTPRequest) {
    req.setCharacterEncoding("UTF-8")
  }

}

object ObjJServer {
  def serve(req: Req)(): Box[LiftResponse] =
  for {
    url <- LiftRules.getResource(req.path.wholePath.mkString("/", "/", ""))
    urlConn <- tryo(url.openConnection)
    lastModified = ResourceServer.calcLastModified(urlConn)
  } yield {
    req.testFor304(lastModified, "Expires" -> toInternetDate(millis + 30.days)) openOr {
      val stream = url.openStream
      StreamingResponse(stream, () => stream.close, urlConn.getContentLength,
                        (if (lastModified == 0L) Nil else
                         List(("Last-Modified", toInternetDate(lastModified)))) :::
                        List(("Expires", toInternetDate(millis + 30.days)),
                             ("Content-Type","application/text")), Nil,
                        200)
    }
  }
  
}
